import type { Metadata } from "next";
import { notFound } from "next/navigation";
import Image from "next/image";
import Link from "next/link";
import { Lock } from "lucide-react";
import { prisma } from "@/lib/prisma";
import { getSessionUser } from "@/lib/auth";
import { avatarImg, lugarImg } from "@/lib/images";
import { mesAnio } from "@/lib/format";
import { SeguirButton } from "@/components/perfil/seguir-button";

type Params = Promise<{ id: string }>;

export async function generateMetadata({ params }: { params: Params }): Promise<Metadata> {
  const { id } = await params;
  const perfil = await prisma.perfil.findUnique({ where: { id }, select: { nombre: true } });
  return { title: perfil?.nombre ?? "Perfil" };
}

export default async function PerfilPublicoPage({ params }: { params: Params }) {
  const { id } = await params;
  const session = await getSessionUser();
  const esDueno = session?.id === id;

  const perfil = await prisma.perfil.findUnique({
    where: { id },
    include: { privacidad: true },
  });
  if (!perfil || perfil.estado !== "activo") notFound();

  const priv = perfil.privacidad ?? {
    perfilPublico: true,
    favoritosPublicos: true,
    comentariosPublicos: true,
    mostrarEstadisticas: true,
  };

  if (!priv.perfilPublico && !esDueno) {
    return (
      <div className="mx-auto flex max-w-md flex-col items-center gap-3 px-4 py-24 text-center">
        <Lock className="size-10 text-muted-foreground" />
        <h1 className="font-heading text-xl font-bold">Perfil privado</h1>
        <p className="text-sm text-muted-foreground">Este usuario decidió mantener su perfil privado.</p>
        <Link href="/" className="text-brand hover:underline">
          Volver al inicio
        </Link>
      </div>
    );
  }

  const [stats, siguiendoYo, insignias, favoritos, aportes] = await Promise.all([
    Promise.all([
      prisma.favorito.count({ where: { idUsuario: id } }),
      prisma.comentario.aggregate({ where: { idUsuario: id }, _avg: { calificacion: true } }),
      prisma.lugarSugerido.count({ where: { idUsuario: id, estado: "aprobado" } }),
      prisma.lugarSugerido.count({ where: { idUsuario: id } }),
      prisma.seguidor.count({ where: { idSeguido: id } }),
      prisma.seguidor.count({ where: { idSeguidor: id } }),
    ]),
    session
      ? prisma.seguidor.findUnique({
          where: { idSeguidor_idSeguido: { idSeguidor: session.id, idSeguido: id } },
        })
      : null,
    prisma.usuarioInsignia.findMany({
      where: { idUsuario: id },
      include: { insignia: true },
      orderBy: { fechaObtencion: "desc" },
    }),
    priv.favoritosPublicos || esDueno
      ? prisma.favorito.findMany({
          where: { idUsuario: id },
          include: { lugar: { include: { departamento: true } } },
          orderBy: { fechaAgregado: "desc" },
          take: 6,
        })
      : Promise.resolve([]),
    prisma.lugarSugerido.findMany({
      where: { idUsuario: id, estado: "aprobado" },
      include: { departamento: true },
      orderBy: { fechaRevision: "desc" },
      take: 6,
    }),
  ]);

  const [totalFav, avgCalif, lugaresAprobados, totalSug, totalSeguidores, totalSiguiendo] = stats;

  return (
    <div className="mx-auto max-w-4xl px-4 py-10">
      <div className="flex flex-col items-center gap-4 rounded-2xl bg-app-gradient p-8 text-center text-white">
        <Image
          src={avatarImg(perfil.imagenPerfil, perfil.nombre)}
          alt={perfil.nombre}
          width={100}
          height={100}
          className="size-24 rounded-full border-4 border-white/30 object-cover"
        />
        <div>
          <h1 className="font-heading text-2xl font-bold">{perfil.nombre}</h1>
          <span className="mt-1 inline-block rounded-full bg-white/20 px-2 py-0.5 text-xs capitalize">
            {perfil.rol}
          </span>
        </div>
        <div className="flex gap-2">
          {esDueno ? (
            <Link href="/perfil" className="rounded-full bg-white px-5 py-2 text-sm font-medium text-brand">
              Editar perfil
            </Link>
          ) : session ? (
            <>
              <SeguirButton idObjetivo={id} initial={!!siguiendoYo} />
              <Link
                href={`/mensajes?chat=${id}`}
                className="rounded-full border border-white/50 px-5 py-2 text-sm font-medium hover:bg-white/10"
              >
                Enviar mensaje
              </Link>
            </>
          ) : null}
        </div>
      </div>

      <p className="mt-3 text-center text-xs text-muted-foreground">
        Miembro desde {mesAnio(perfil.fechaRegistro)}
      </p>

      {priv.mostrarEstadisticas || esDueno ? (
        <div className="mt-6 grid grid-cols-3 gap-3 sm:grid-cols-6">
          {[
            ["Favoritos", totalFav],
            ["Promedio", (avgCalif._avg.calificacion ?? 0).toFixed(1)],
            ["Aprobados", lugaresAprobados],
            ["Sugerencias", totalSug],
            ["Seguidores", totalSeguidores],
            ["Siguiendo", totalSiguiendo],
          ].map(([k, v]) => (
            <div key={k as string} className="rounded-xl border bg-card p-3 text-center">
              <div className="text-lg font-bold">{v}</div>
              <div className="text-[10px] uppercase text-muted-foreground">{k}</div>
            </div>
          ))}
        </div>
      ) : (
        <p className="mt-6 rounded-xl border bg-secondary p-4 text-center text-sm text-muted-foreground">
          Este usuario ocultó sus estadísticas.
        </p>
      )}

      {insignias.length > 0 && (
        <section className="mt-8 rounded-2xl border p-5">
          <h2 className="font-heading font-semibold">Insignias</h2>
          <div className="mt-3 flex flex-wrap gap-2">
            {insignias.map((ui) => (
              <span
                key={ui.idInsignia}
                title={ui.insignia.descripcion ?? undefined}
                className="rounded-full bg-brand/10 px-3 py-1.5 text-sm font-medium text-brand"
              >
                🏅 {ui.insignia.nombre}
              </span>
            ))}
          </div>
        </section>
      )}

      {priv.favoritosPublicos || esDueno ? (
        favoritos.length > 0 && (
          <section className="mt-8">
            <h2 className="font-heading text-lg font-semibold">Lugares favoritos</h2>
            <div className="mt-3 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
              {favoritos.map((f) => (
                <Link key={f.idLugar} href={`/lugares/${f.idLugar}`} className="overflow-hidden rounded-xl border">
                  <div className="relative aspect-video">
                    <Image src={lugarImg(f.lugar.imagen)} alt={f.lugar.nombre} fill className="object-cover" />
                  </div>
                  <div className="p-2">
                    <p className="truncate text-sm font-medium">{f.lugar.nombre}</p>
                    <p className="text-xs text-muted-foreground">{f.lugar.departamento?.nombre}</p>
                  </div>
                </Link>
              ))}
            </div>
            {totalFav > 6 && <p className="mt-2 text-xs text-muted-foreground">y {totalFav - 6} lugares más…</p>}
          </section>
        )
      ) : (
        <section className="mt-8 rounded-2xl border bg-secondary p-5 text-center text-sm text-muted-foreground">
          <Lock className="mx-auto mb-1 size-5" /> Favoritos privados
        </section>
      )}

      {aportes.length > 0 && (
        <section className="mt-8">
          <h2 className="font-heading text-lg font-semibold">Lugares aportados a Catamap</h2>
          <div className="mt-3 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {aportes.map((s) => (
              <div key={s.id} className="overflow-hidden rounded-xl border">
                {s.imagen && (
                  <div className="relative aspect-video">
                    <Image src={s.imagen} alt={s.nombre} fill className="object-cover" />
                  </div>
                )}
                <div className="p-2">
                  <p className="truncate text-sm font-medium">{s.nombre}</p>
                  <p className="text-xs text-muted-foreground">{s.departamento?.nombre}</p>
                </div>
              </div>
            ))}
          </div>
        </section>
      )}

      <div className="mt-10 text-center">
        <Link href="/" className="text-sm text-brand hover:underline">
          Volver al inicio
        </Link>
      </div>
    </div>
  );
}
