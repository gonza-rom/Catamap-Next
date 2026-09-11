"use server";

import { revalidatePath } from "next/cache";
import { z } from "zod";
import { prisma } from "@/lib/prisma";
import { requireAdmin } from "@/lib/auth";

type Res = { ok: true } | { ok: false; error: string };

// ── Usuarios ─────────────────────────────────────────────
const usuarioSchema = z.object({
  id: z.string().uuid(),
  nombre: z.string().trim().min(1).optional(),
  rol: z.enum(["usuario", "emprendedor", "admin"]).optional(),
  estado: z.enum(["activo", "suspendido", "inactivo"]).optional(),
  telefono: z.string().trim().optional(),
});

export async function adminActualizarUsuario(input: unknown): Promise<Res> {
  await requireAdmin();
  const parsed = usuarioSchema.safeParse(input);
  if (!parsed.success) return { ok: false, error: parsed.error.issues[0].message };
  const { id, ...data } = parsed.data;
  await prisma.perfil.update({ where: { id }, data });
  revalidatePath("/admin/usuarios");
  return { ok: true };
}

export async function adminEliminarUsuario(id: string): Promise<Res> {
  const session = await requireAdmin();
  if (session.id === id) return { ok: false, error: "No podés eliminarte a vos mismo" };
  await prisma.perfil.delete({ where: { id } });
  revalidatePath("/admin/usuarios");
  return { ok: true };
}

// ── Lugares turísticos ───────────────────────────────────
const lugarSchema = z.object({
  id: z.number().int(),
  nombre: z.string().trim().min(1).optional(),
  descripcion: z.string().trim().optional(),
  direccion: z.string().trim().optional(),
  estado: z.enum(["aprobado", "pendiente", "rechazado"]).optional(),
  idCategoria: z.number().int().nullable().optional(),
  idDepartamento: z.number().int().nullable().optional(),
  imagen: z.string().url().optional(),
});

export async function adminActualizarLugar(input: unknown): Promise<Res> {
  await requireAdmin();
  const parsed = lugarSchema.safeParse(input);
  if (!parsed.success) return { ok: false, error: parsed.error.issues[0].message };
  const { id, ...data } = parsed.data;
  await prisma.lugar.update({ where: { id }, data });
  revalidatePath("/admin/lugares");
  revalidatePath(`/lugares/${id}`);
  return { ok: true };
}

export async function adminEliminarLugar(id: number): Promise<Res> {
  await requireAdmin();
  await prisma.$transaction([
    prisma.favorito.deleteMany({ where: { idLugar: id } }),
    prisma.comentario.deleteMany({ where: { idLugar: id } }),
    prisma.lugar.delete({ where: { id } }),
  ]);
  revalidatePath("/admin/lugares");
  revalidatePath("/lugares");
  return { ok: true };
}

// ── Sugerencias ──────────────────────────────────────────
export async function adminAprobarSugerencia(id: number): Promise<Res> {
  await requireAdmin();
  const s = await prisma.lugarSugerido.findUnique({ where: { id } });
  if (!s) return { ok: false, error: "Sugerencia no encontrada" };

  await prisma.$transaction(async (tx) => {
    const lugar = await tx.lugar.create({
      data: {
        nombre: s.nombre,
        descripcion: s.descripcion,
        direccion: s.direccion,
        lat: s.lat,
        lng: s.lng,
        imagen: s.imagen,
        idCategoria: s.idCategoria,
        idDepartamento: s.idDepartamento,
        estado: "aprobado",
      },
    });
    await tx.lugarSugerido.update({
      where: { id },
      data: { estado: "aprobado", fechaRevision: new Date(), lugarPublicado: { connect: { id: lugar.id } } },
    });
  });

  revalidatePath("/admin/sugerencias");
  revalidatePath("/lugares");
  revalidatePath("/mapa");
  return { ok: true };
}

export async function adminRechazarSugerencia(id: number, motivo?: string): Promise<Res> {
  await requireAdmin();
  await prisma.lugarSugerido.update({
    where: { id },
    data: { estado: "rechazado", fechaRevision: new Date(), motivoRechazo: motivo || null },
  });
  revalidatePath("/admin/sugerencias");
  return { ok: true };
}

export async function adminEliminarSugerencia(id: number): Promise<Res> {
  await requireAdmin();
  await prisma.lugarSugerido.delete({ where: { id } });
  revalidatePath("/admin/sugerencias");
  return { ok: true };
}

// ── Comentarios ──────────────────────────────────────────
export async function adminCambiarEstadoComentario(
  id: number,
  estado: "pendiente" | "aprobado" | "rechazado",
): Promise<Res> {
  await requireAdmin();
  await prisma.comentario.update({ where: { id }, data: { estado } });
  revalidatePath("/admin/comentarios");
  return { ok: true };
}

export async function adminEliminarComentario(id: number): Promise<Res> {
  await requireAdmin();
  await prisma.comentario.delete({ where: { id } });
  revalidatePath("/admin/comentarios");
  return { ok: true };
}

// ── Categorías ───────────────────────────────────────────
const categoriaSchema = z.object({
  nombre: z.string().trim().min(1),
  descripcion: z.string().trim().optional(),
  icono: z.string().trim().min(1),
});

export async function adminCrearCategoria(input: unknown): Promise<Res> {
  await requireAdmin();
  const parsed = categoriaSchema.safeParse(input);
  if (!parsed.success) return { ok: false, error: parsed.error.issues[0].message };
  await prisma.categoria.create({ data: parsed.data });
  revalidatePath("/admin/categorias");
  return { ok: true };
}

export async function adminActualizarCategoria(id: number, input: unknown): Promise<Res> {
  await requireAdmin();
  const parsed = categoriaSchema.partial().safeParse(input);
  if (!parsed.success) return { ok: false, error: parsed.error.issues[0].message };
  await prisma.categoria.update({ where: { idCategoria: id }, data: parsed.data });
  revalidatePath("/admin/categorias");
  return { ok: true };
}

export async function adminEliminarCategoria(id: number): Promise<Res> {
  await requireAdmin();
  const total = await prisma.lugar.count({ where: { idCategoria: id } });
  if (total > 0) return { ok: false, error: `No se puede eliminar: tiene ${total} lugares asociados` };
  await prisma.categoria.delete({ where: { idCategoria: id } });
  revalidatePath("/admin/categorias");
  return { ok: true };
}

// ── Departamentos ────────────────────────────────────────
export async function adminActualizarDepartamento(id: number, nombre: string): Promise<Res> {
  await requireAdmin();
  if (!nombre.trim()) return { ok: false, error: "Nombre requerido" };
  await prisma.departamento.update({ where: { id }, data: { nombre: nombre.trim() } });
  revalidatePath("/admin/departamentos");
  return { ok: true };
}

export async function adminEliminarDepartamento(id: number): Promise<Res> {
  await requireAdmin();
  const total = await prisma.lugar.count({ where: { idDepartamento: id } });
  if (total > 0) return { ok: false, error: `No se puede eliminar: tiene ${total} lugares asociados` };
  await prisma.departamento.delete({ where: { id } });
  revalidatePath("/admin/departamentos");
  return { ok: true };
}
