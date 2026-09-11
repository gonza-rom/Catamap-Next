import type { Metadata } from "next";
import Image from "next/image";
import { requireUser } from "@/lib/auth";
import { prisma } from "@/lib/prisma";
import { getFiltros } from "@/lib/data/lugares";
import { avatarImg } from "@/lib/images";
import { mesAnio } from "@/lib/format";
import { PerfilTabs } from "@/components/perfil/perfil-tabs";

export const metadata: Metadata = { title: "Mi perfil" };

export default async function PerfilPage() {
  const { id, email, perfil } = await requireUser();

  const [
    favoritos,
    resenas,
    sugerencias,
    seguidores,
    siguiendo,
    privacidad,
    filtros,
    resenasAprobadas,
  ] = await Promise.all([
    prisma.favorito.findMany({
      where: { idUsuario: id },
      include: { lugar: { include: { categoria: true, departamento: true } } },
      orderBy: { fechaAgregado: "desc" },
    }),
    prisma.comentario.findMany({
      where: { idUsuario: id },
      include: { lugar: { select: { id: true, nombre: true } } },
      orderBy: { fechaCreacion: "desc" },
    }),
    prisma.lugarSugerido.findMany({
      where: { idUsuario: id },
      include: { departamento: true, categoria: true },
      orderBy: { fechaSugerido: "desc" },
    }),
    prisma.seguidor.findMany({
      where: { idSeguido: id },
      include: { seguidor: { select: { id: true, nombre: true, imagenPerfil: true } } },
      orderBy: { fechaInicio: "desc" },
    }),
    prisma.seguidor.findMany({
      where: { idSeguidor: id },
      include: { seguido: { select: { id: true, nombre: true, imagenPerfil: true } } },
      orderBy: { fechaInicio: "desc" },
    }),
    prisma.configuracionPrivacidad.findUnique({ where: { idUsuario: id } }),
    getFiltros(),
    prisma.comentario.count({ where: { idUsuario: id, estado: "aprobado" } }),
  ]);

  const stats = {
    favoritos: favoritos.length,
    resenas: resenasAprobadas,
    seguidores: seguidores.length,
    siguiendo: siguiendo.length,
  };

  return (
    <div className="mx-auto max-w-5xl px-4 py-8">
      {/* Header */}
      <div className="flex flex-col items-center gap-4 rounded-2xl bg-app-gradient p-6 text-center text-white sm:flex-row sm:text-left">
        <Image
          src={avatarImg(perfil.imagenPerfil, perfil.nombre)}
          alt={perfil.nombre}
          width={88}
          height={88}
          className="size-22 rounded-full border-4 border-white/30 object-cover"
        />
        <div className="flex-1">
          <h1 className="font-heading text-2xl font-bold">{perfil.nombre}</h1>
          <p className="text-white/80">{email}</p>
          <span className="mt-1 inline-block rounded-full bg-white/20 px-2 py-0.5 text-xs capitalize">
            {perfil.rol}
          </span>
        </div>
        <div className="grid grid-cols-4 gap-3 text-center">
          {[
            ["Favoritos", stats.favoritos],
            ["Reseñas", stats.resenas],
            ["Seguidores", stats.seguidores],
            ["Siguiendo", stats.siguiendo],
          ].map(([k, v]) => (
            <div key={k as string}>
              <div className="text-xl font-bold">{v as number}</div>
              <div className="text-[11px] uppercase text-white/70">{k as string}</div>
            </div>
          ))}
        </div>
      </div>

      <p className="mt-2 text-xs text-muted-foreground">
        Miembro desde {mesAnio(perfil.fechaRegistro)}
      </p>

      <PerfilTabs
        userId={id}
        email={email}
        perfil={{ nombre: perfil.nombre, telefono: perfil.telefono, bio: perfil.bio }}
        privacidad={{
          perfilPublico: privacidad?.perfilPublico ?? true,
          favoritosPublicos: privacidad?.favoritosPublicos ?? true,
          comentariosPublicos: privacidad?.comentariosPublicos ?? true,
          mostrarEstadisticas: privacidad?.mostrarEstadisticas ?? true,
        }}
        categorias={filtros.categorias.map((c) => ({ id: c.idCategoria, nombre: c.nombre }))}
        departamentos={filtros.departamentos.map((d) => ({ id: d.id, nombre: d.nombre }))}
        favoritos={favoritos.map((f) => ({
          idLugar: f.idLugar,
          nombre: f.lugar.nombre,
          imagen: f.lugar.imagen,
          categoria: f.lugar.categoria?.nombre ?? null,
          departamento: f.lugar.departamento?.nombre ?? null,
        }))}
        resenas={resenas.map((r) => ({
          id: r.id,
          lugarId: r.lugar.id,
          lugarNombre: r.lugar.nombre,
          calificacion: r.calificacion,
          comentario: r.comentario,
          estado: r.estado,
          fecha: r.fechaCreacion.toISOString(),
        }))}
        sugerencias={sugerencias.map((s) => ({
          id: s.id,
          nombre: s.nombre,
          descripcion: s.descripcion,
          imagen: s.imagen,
          estado: s.estado,
          motivoRechazo: s.motivoRechazo,
          departamento: s.departamento?.nombre ?? null,
          fecha: s.fechaSugerido.toISOString(),
        }))}
        seguidores={seguidores.map((s) => ({
          id: s.seguidor.id,
          nombre: s.seguidor.nombre,
          imagen: s.seguidor.imagenPerfil,
        }))}
        siguiendo={siguiendo.map((s) => ({
          id: s.seguido.id,
          nombre: s.seguido.nombre,
          imagen: s.seguido.imagenPerfil,
        }))}
      />
    </div>
  );
}
