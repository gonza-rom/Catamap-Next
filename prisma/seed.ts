/**
 * Seed de Catamap: importa el dump del proyecto PHP (data/catamap.json, export JSON de phpMyAdmin)
 * a Supabase (Postgres + Auth).
 *
 * - Cada `usuarios` del dump -> usuario en Supabase Auth (password = SEED_DEFAULT_PASSWORD) + `Perfil`.
 * - Los IDs int de usuario se remapean a los uuid de Supabase.
 * - Catálogos (categorias, departamentos, insignias), 1419 lugares y el resto de los datos.
 *
 * Idempotente: borra las tablas de la app y reusa los usuarios de Auth que ya existan (por email).
 *
 * Ejecutar:  npm run db:seed
 */
import "dotenv/config";
import { readFileSync, readdirSync } from "node:fs";
import { join } from "node:path";
import { PrismaClient, Rol, EstadoUsuario } from "../src/generated/prisma";
import { createClient } from "@supabase/supabase-js";

const prisma = new PrismaClient();

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY!;
const DEFAULT_PASSWORD = process.env.SEED_DEFAULT_PASSWORD || "Catamap123!";
const ADMIN_EMAIL = process.env.NEXT_PUBLIC_ADMIN_EMAIL;

if (!supabaseUrl || !serviceKey) {
  throw new Error("Faltan NEXT_PUBLIC_SUPABASE_URL / SUPABASE_SERVICE_ROLE_KEY en .env");
}

const admin = createClient(supabaseUrl, serviceKey, {
  auth: { autoRefreshToken: false, persistSession: false },
});

// ── helpers ────────────────────────────────────────────────
type Row = Record<string, string | null>;
const int = (v: string | null) => (v == null || v === "" ? null : parseInt(v, 10));
const num = (v: string | null) => (v == null || v === "" ? null : parseFloat(v));
const bool = (v: string | null) => v === "1" || v === "true";
const date = (v: string | null) => (v && v !== "0000-00-00 00:00:00" ? new Date(v.replace(" ", "T") + "Z") : null);

function loadDump() {
  const raw = JSON.parse(readFileSync(join(process.cwd(), "data", "catamap.json"), "utf8")) as Array<{
    type: string;
    name?: string;
    data?: Row[];
  }>;
  const tables: Record<string, Row[]> = {};
  for (const el of raw) if (el.type === "table" && el.name) tables[el.name] = el.data ?? [];
  return tables;
}

/** Nombres de archivo presentes en public/img-catamarca (para descartar imágenes rotas). */
const imgCatamarca = new Set(
  readdirSync(join(process.cwd(), "public", "img-catamarca")).map((f) => f.toLowerCase()),
);
const uploadsFiles = new Set(
  readdirSync(join(process.cwd(), "public", "uploads")).map((f) => f.toLowerCase()),
);

function mapLugarImagen(raw: string | null): string | null {
  if (!raw) return null;
  const file = raw.split("/").pop()!;
  if (file.toLowerCase() === "default.jpg") return null;
  return imgCatamarca.has(file.toLowerCase()) ? `/img-catamarca/${file}` : null;
}

function mapUploadImagen(raw: string | null): string | null {
  if (!raw) return null;
  const file = raw.split("/").pop()!;
  return uploadsFiles.has(file.toLowerCase()) ? `/uploads/${file}` : null;
}

function mapRol(tipo: string | null, rol: string | null): Rol {
  const v = (rol || tipo || "usuario").toLowerCase();
  if (v === "admin" || v === "administrador") return Rol.admin;
  if (v === "emprendedor") return Rol.emprendedor;
  return Rol.usuario;
}

function mapEstado(estado: string | null): EstadoUsuario {
  const v = (estado || "activo").toLowerCase();
  if (v === "inactivo") return EstadoUsuario.inactivo;
  if (v === "suspendido") return EstadoUsuario.suspendido;
  return EstadoUsuario.activo;
}

/** Devuelve el uuid del usuario de Auth con ese email; lo crea si no existe. */
async function getOrCreateAuthUser(email: string): Promise<string> {
  // buscar en las páginas de usuarios existentes
  for (let page = 1; page <= 20; page++) {
    const { data, error } = await admin.auth.admin.listUsers({ page, perPage: 1000 });
    if (error) throw error;
    const found = data.users.find((u) => u.email?.toLowerCase() === email.toLowerCase());
    if (found) return found.id;
    if (data.users.length < 1000) break;
  }
  const { data, error } = await admin.auth.admin.createUser({
    email,
    password: DEFAULT_PASSWORD,
    email_confirm: true,
  });
  if (error) throw error;
  return data.user.id;
}

// ── seed ───────────────────────────────────────────────────
async function main() {
  const t = loadDump();
  console.log("Dump cargado:", Object.fromEntries(Object.entries(t).map(([k, v]) => [k, v.length])));

  // 1. Limpiar tablas de la app (respeta FKs)
  console.log("Limpiando tablas…");
  await prisma.$transaction([
    prisma.usuarioInsignia.deleteMany(),
    prisma.mensaje.deleteMany(),
    prisma.seguidor.deleteMany(),
    prisma.favorito.deleteMany(),
    prisma.comentario.deleteMany(),
    prisma.configuracionPrivacidad.deleteMany(),
    prisma.lugar.deleteMany(),
    prisma.lugarSugerido.deleteMany(),
    prisma.perfil.deleteMany(),
    prisma.insignia.deleteMany(),
    prisma.categoria.deleteMany(),
    prisma.departamento.deleteMany(),
  ]);

  // 2. Usuarios -> Supabase Auth + Perfil
  const idMap = new Map<number, string>(); // id int del dump -> uuid
  for (const u of t.usuarios) {
    const oldId = int(u.id)!;
    const email = u.email!.trim().toLowerCase();
    const uuid = await getOrCreateAuthUser(email);
    idMap.set(oldId, uuid);
    await prisma.perfil.create({
      data: {
        id: uuid,
        nombre: u.nombre?.trim() || email,
        rol: mapRol(u.tipo_usuario, u.rol),
        estado: mapEstado(u.estado),
        imagenPerfil: mapUploadImagen(u.imagen_perfil),
        telefono: u.telefono || null,
        fechaRegistro: date(u.fecha_registro) ?? new Date(),
        ultimoAcceso: date(u.ultimo_acceso),
      },
    });
    console.log(`  usuario ${email} -> ${uuid} (${mapRol(u.tipo_usuario, u.rol)})`);
  }

  // 2b. Admin propio (NEXT_PUBLIC_ADMIN_EMAIL) si no está en el dump
  if (ADMIN_EMAIL && ![...t.usuarios].some((u) => u.email?.toLowerCase() === ADMIN_EMAIL.toLowerCase())) {
    const uuid = await getOrCreateAuthUser(ADMIN_EMAIL);
    await prisma.perfil.upsert({
      where: { id: uuid },
      create: { id: uuid, nombre: "Admin", rol: Rol.admin, estado: EstadoUsuario.activo },
      update: { rol: Rol.admin },
    });
    console.log(`  admin propio ${ADMIN_EMAIL} -> ${uuid}`);
  }

  // 3. Catálogos
  await prisma.categoria.createMany({
    data: t.categorias.map((c) => ({
      idCategoria: int(c.id_categoria)!,
      nombre: c.nombre!,
      descripcion: c.descripcion || null,
      icono: c.icono || "❓",
    })),
  });
  await prisma.departamento.createMany({
    data: t.departamentos.map((d) => ({ id: int(d.id)!, nombre: d.nombre! })),
  });
  await prisma.insignia.createMany({
    data: t.insignias.map((i) => ({
      id: int(i.id)!,
      nombre: i.nombre!,
      descripcion: i.descripcion || null,
      icono: i.icono || null,
      criterio: i.criterio || null,
      puntosRequeridos: int(i.puntos_requeridos) ?? 0,
    })),
  });
  console.log("Catálogos OK");

  // 4. Lugares turísticos
  const catIds = new Set(t.categorias.map((c) => int(c.id_categoria)));
  const depIds = new Set(t.departamentos.map((d) => int(d.id)));
  const lugares = t.lugares_turisticos.map((l) => ({
    id: int(l.id)!,
    nombre: l.nombre!,
    descripcion: l.descripcion || null,
    direccion: l.direccion || null,
    lat: num(l.lat),
    lng: num(l.lng),
    imagen: mapLugarImagen(l.imagen),
    idCategoria: catIds.has(int(l.id_categoria)) ? int(l.id_categoria) : null,
    idDepartamento: depIds.has(int(l.id_departamento)) ? int(l.id_departamento) : null,
    estado: (l.estado as "pendiente" | "aprobado" | "rechazado") || "aprobado",
  }));
  for (let i = 0; i < lugares.length; i += 500) {
    await prisma.lugar.createMany({ data: lugares.slice(i, i + 500) });
  }
  console.log(`Lugares: ${lugares.length}`);

  // 5. Lugares sugeridos
  for (const s of t.lugares_sugeridos) {
    const idUsuario = idMap.get(int(s.id_usuario)!);
    if (!idUsuario) continue;
    await prisma.lugarSugerido.create({
      data: {
        id: int(s.id)!,
        idUsuario,
        nombre: s.nombre!,
        descripcion: s.descripcion || null,
        direccion: s.direccion || null,
        lat: num(s.lat) ?? 0,
        lng: num(s.lng) ?? 0,
        idCategoria: catIds.has(int(s.id_categoria)) ? int(s.id_categoria) : null,
        idDepartamento: depIds.has(int(s.id_departamento)) ? int(s.id_departamento) : null,
        imagen: mapUploadImagen(s.imagen),
        estado: (s.estado as "pendiente" | "aprobado" | "rechazado") || "pendiente",
        motivoRechazo: s.motivo_rechazo || null,
        fechaSugerido: date(s.fecha_sugerido) ?? new Date(),
        fechaRevision: date(s.fecha_revision),
        revisadoPor: s.revisado_por ? idMap.get(int(s.revisado_por)!) ?? null : null,
      },
    });
  }
  console.log(`Sugerencias: ${t.lugares_sugeridos.length}`);

  // 6. Comentarios / favoritos / seguidores / mensajes / insignias / privacidad
  const lugarIds = new Set(lugares.map((l) => l.id));

  for (const c of t.comentarios) {
    const idUsuario = idMap.get(int(c.id_usuario)!);
    if (!idUsuario || !lugarIds.has(int(c.id_lugar)!)) continue;
    await prisma.comentario.create({
      data: {
        id: int(c.id)!,
        idLugar: int(c.id_lugar)!,
        idUsuario,
        calificacion: int(c.calificacion) ?? 3,
        comentario: c.comentario!,
        estado: (c.estado as "pendiente" | "aprobado" | "rechazado") || "pendiente",
        fechaCreacion: date(c.fecha_creacion) ?? new Date(),
        fechaModificacion: date(c.fecha_modificacion),
      },
    });
  }

  for (const f of t.favoritos) {
    const idUsuario = idMap.get(int(f.id_usuario)!);
    if (!idUsuario || !lugarIds.has(int(f.id_lugar)!)) continue;
    await prisma.favorito.create({
      data: {
        id: int(f.id)!,
        idUsuario,
        idLugar: int(f.id_lugar)!,
        fechaAgregado: date(f.fecha_agregado) ?? new Date(),
      },
    });
  }

  for (const s of t.seguidores) {
    const a = idMap.get(int(s.id_seguidor)!);
    const b = idMap.get(int(s.id_seguido)!);
    if (!a || !b) continue;
    await prisma.seguidor.create({
      data: { id: int(s.id)!, idSeguidor: a, idSeguido: b, fechaInicio: date(s.fecha_inicio) ?? new Date() },
    });
  }

  for (const m of t.mensajes) {
    const a = idMap.get(int(m.id_remitente)!);
    const b = idMap.get(int(m.id_destinatario)!);
    if (!a || !b) continue;
    await prisma.mensaje.create({
      data: {
        id: int(m.id)!,
        idRemitente: a,
        idDestinatario: b,
        mensaje: m.mensaje!,
        leido: bool(m.leido),
        fechaEnvio: date(m.fecha_envio) ?? new Date(),
      },
    });
  }

  for (const ui of t.usuarios_insignias) {
    const idUsuario = idMap.get(int(ui.id_usuario)!);
    if (!idUsuario) continue;
    await prisma.usuarioInsignia.create({
      data: {
        idUsuario,
        idInsignia: int(ui.id_insignia)!,
        fechaObtencion: date(ui.fecha_obtencion) ?? new Date(),
      },
    });
  }

  // privacidad: la del dump + defaults para cualquier usuario sin fila
  const privById = new Map(t.configuracion_privacidad.map((p) => [int(p.id_usuario)!, p]));
  for (const [oldId, uuid] of idMap) {
    const p = privById.get(oldId);
    await prisma.configuracionPrivacidad.create({
      data: {
        idUsuario: uuid,
        perfilPublico: p ? bool(p.perfil_publico) : true,
        favoritosPublicos: p ? bool(p.favoritos_publicos) : true,
        comentariosPublicos: p ? bool(p.comentarios_publicos) : true,
        mostrarEstadisticas: p ? bool(p.mostrar_estadisticas) : true,
      },
    });
  }
  console.log("Relaciones OK");

  // 7. Ajustar secuencias de autoincrement
  const seqs: [string, string][] = [
    ["categorias", "id_categoria"],
    ["departamentos", "id"],
    ["insignias", "id"],
    ["lugares_turisticos", "id"],
    ["lugares_sugeridos", "id"],
    ["comentarios", "id"],
    ["favoritos", "id"],
    ["seguidores", "id"],
    ["mensajes", "id"],
    ["configuracion_privacidad", "id"],
  ];
  for (const [table, col] of seqs) {
    await prisma.$executeRawUnsafe(
      `SELECT setval(pg_get_serial_sequence('"${table}"', '${col}'), COALESCE((SELECT MAX("${col}") FROM "${table}"), 1), true)`,
    );
  }
  console.log("Secuencias ajustadas");

  console.log("\n✅ Seed completo.");
  console.log(`   Usuarios de prueba (password: ${DEFAULT_PASSWORD}):`);
  for (const u of t.usuarios) console.log(`   - ${u.email}  [${mapRol(u.tipo_usuario, u.rol)}]`);
}

main()
  .then(() => prisma.$disconnect())
  .catch(async (e) => {
    console.error(e);
    await prisma.$disconnect();
    process.exit(1);
  });
