import { notFound } from "next/navigation";
import type { Metadata } from "next";
import Image from "next/image";
import Link from "next/link";
import { MapPin, Tag } from "lucide-react";
import { prisma } from "@/lib/prisma";
import { getSessionUser } from "@/lib/auth";
import { lugarImg } from "@/lib/images";
import { fechaHora } from "@/lib/format";
import { Estrellas } from "@/components/lugares/estrellas";
import { FavoritoButton } from "@/components/lugares/favorito-button";
import { ComentariosSection } from "@/components/lugares/comentarios-section";
import { MiniMapa } from "@/components/map/mini-mapa-lazy";

type Params = Promise<{ id: string }>;

export async function generateMetadata({ params }: { params: Params }): Promise<Metadata> {
  const { id } = await params;
  const lugar = await prisma.lugar.findUnique({ where: { id: Number(id) }, select: { nombre: true } });
  return { title: lugar?.nombre ?? "Lugar" };
}

export default async function DetalleLugarPage({ params }: { params: Params }) {
  const { id } = await params;
  const lugarId = Number(id);
  if (!Number.isInteger(lugarId)) notFound();

  const session = await getSessionUser();

  const lugar = await prisma.lugar.findUnique({
    where: { id: lugarId },
    include: { categoria: true, departamento: true },
  });
  if (!lugar) notFound();

  const [comentarios, agg, favorito, miComentario] = await Promise.all([
    prisma.comentario.findMany({
      where: { idLugar: lugarId, estado: "aprobado" },
      include: { usuario: { select: { id: true, nombre: true, imagenPerfil: true } } },
      orderBy: { fechaCreacion: "desc" },
    }),
    prisma.comentario.aggregate({
      where: { idLugar: lugarId, estado: "aprobado" },
      _avg: { calificacion: true },
      _count: true,
    }),
    session
      ? prisma.favorito.findUnique({
          where: { idUsuario_idLugar: { idUsuario: session.id, idLugar: lugarId } },
        })
      : null,
    session
      ? prisma.comentario.findUnique({
          where: { idUsuario_idLugar: { idUsuario: session.id, idLugar: lugarId } },
        })
      : null,
  ]);

  const promedio = agg._avg.calificacion ?? 0;

  return (
    <div>
      {/* Hero */}
      <div className="relative h-[42vh] min-h-72 w-full">
        <Image src={lugarImg(lugar.imagen)} alt={lugar.nombre} fill priority className="object-cover" />
        <div className="absolute inset-0 bg-gradient-to-t from-black/75 to-black/10" />
        {session && (
          <div className="absolute right-4 top-4">
            <FavoritoButton idLugar={lugar.id} initial={!!favorito} isAuthenticated className="size-11" />
          </div>
        )}
        <div className="absolute bottom-0 left-0 w-full p-6 text-white">
          <div className="mx-auto max-w-5xl">
            <h1 className="font-heading text-3xl font-extrabold sm:text-4xl">{lugar.nombre}</h1>
            <div className="mt-2 flex flex-wrap items-center gap-4 text-sm text-white/85">
              {lugar.departamento && (
                <span className="flex items-center gap-1">
                  <MapPin className="size-4" /> {lugar.departamento.nombre}
                </span>
              )}
              {lugar.categoria && (
                <span className="flex items-center gap-1">
                  <Tag className="size-4" /> {lugar.categoria.icono} {lugar.categoria.nombre}
                </span>
              )}
              {agg._count > 0 && (
                <span className="flex items-center gap-1">
                  <Estrellas value={promedio} size={14} /> {promedio.toFixed(1)} ({agg._count})
                </span>
              )}
            </div>
          </div>
        </div>
      </div>

      <div className="mx-auto grid max-w-5xl gap-8 px-4 py-10 lg:grid-cols-[1fr_300px]">
        <div className="space-y-8">
          <section className="rounded-2xl border bg-card p-6">
            <h2 className="font-heading text-xl font-semibold">Descripción</h2>
            <p className="mt-2 whitespace-pre-line text-foreground/90">
              {lugar.descripcion || "Este lugar todavía no tiene descripción."}
            </p>
          </section>

          {lugar.lat != null && lugar.lng != null && (
            <section className="rounded-2xl border bg-card p-6">
              <h2 className="font-heading text-xl font-semibold">Ubicación</h2>
              {lugar.direccion && <p className="mt-1 text-sm text-muted-foreground">{lugar.direccion}</p>}
              <div className="mt-3">
                <MiniMapa lat={lugar.lat} lng={lugar.lng} nombre={lugar.nombre} />
              </div>
              <Link
                href={`/mapa?lugar=${lugar.id}`}
                className="mt-3 inline-block text-sm font-medium text-brand hover:underline"
              >
                Ver en el mapa completo →
              </Link>
            </section>
          )}

          <ComentariosSection
            idLugar={lugar.id}
            isAuthenticated={!!session}
            promedio={promedio}
            total={agg._count}
            miEstado={miComentario?.estado ?? null}
            miComentario={
              miComentario
                ? { calificacion: miComentario.calificacion, comentario: miComentario.comentario }
                : null
            }
            comentarios={comentarios.map((c) => ({
              id: c.id,
              usuarioId: c.usuario.id,
              usuarioNombre: c.usuario.nombre,
              usuarioImagen: c.usuario.imagenPerfil,
              calificacion: c.calificacion,
              comentario: c.comentario,
              fecha: fechaHora(c.fechaCreacion),
            }))}
          />
        </div>

        <aside className="lg:sticky lg:top-24 lg:self-start">
          <div className="space-y-3 rounded-2xl border bg-card p-5">
            <h3 className="font-heading font-semibold">Acciones</h3>
            <Link
              href={`/mapa?lugar=${lugar.id}`}
              className="block rounded-full bg-brand px-4 py-2 text-center text-sm font-medium text-white hover:bg-brand-dark"
            >
              Ver en mapa
            </Link>
            <Link
              href="/lugares"
              className="block rounded-full border px-4 py-2 text-center text-sm font-medium hover:bg-accent"
            >
              Volver a lugares
            </Link>
            {session && (
              <FavoritoButton
                idLugar={lugar.id}
                initial={!!favorito}
                isAuthenticated
                variant="button"
                className="w-full justify-center"
              />
            )}
          </div>
        </aside>
      </div>
    </div>
  );
}
