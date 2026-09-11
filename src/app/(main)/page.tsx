import Image from "next/image";
import Link from "next/link";
import { Compass, MapPinned, MessagesSquare, Star } from "lucide-react";
import { prisma } from "@/lib/prisma";
import { getSessionUser } from "@/lib/auth";
import { lugarImg } from "@/lib/images";
import { LugarCard } from "@/components/lugares/lugar-card";
import { HomeCtaButton } from "@/components/home/home-cta-button";

const DESTINO_IDS = [3, 9, 17, 24, 6, 2];
const GALLERY = [
  "tuneles-merced.JPG",
  "termas-de-fiambala.jpg",
  "salton-balcozna.JPG",
  "ruta-de-los-seismiles.jpg",
  "Plaza_25_de_Mayo.jpeg",
  "Mirador-Jumeal.jpg",
  "dique-collagasta.jpg",
  "dunas-taton.jpg",
  "ruta-adobe.jpg",
  "cuesta-la-chilca.jpg",
  "cerro-ancasti.jpg",
  "portezuelo.jpg",
];

export default async function HomePage() {
  const session = await getSessionUser();

  const [destinos, favoritos, totalLugares] = await Promise.all([
    prisma.lugar.findMany({
      where: { id: { in: DESTINO_IDS } },
      include: { categoria: true, departamento: true },
    }),
    session
      ? prisma.favorito.findMany({ where: { idUsuario: session.id }, select: { idLugar: true } })
      : Promise.resolve([]),
    prisma.lugar.count({ where: { estado: "aprobado" } }),
  ]);

  const favSet = new Set(favoritos.map((f) => f.idLugar));

  return (
    <>
      {/* Hero */}
      <section className="relative isolate overflow-hidden">
        <Image
          src="/img/rutanartural.jpg"
          alt="Paisajes de Catamarca"
          fill
          priority
          className="-z-10 object-cover brightness-[0.55]"
        />
        <div className="mx-auto max-w-4xl px-4 py-28 text-center text-white sm:py-36">
          <p className="mb-3 text-sm font-semibold uppercase tracking-[0.2em] text-brand">
            Turismo colaborativo
          </p>
          <h1 className="font-heading text-4xl font-extrabold leading-tight sm:text-6xl">
            Descubrí la Catamarca que no está en las postales
          </h1>
          <p className="mx-auto mt-5 max-w-2xl text-lg text-white/85">
            Un mapa interactivo con {totalLugares.toLocaleString("es-AR")} lugares turísticos, hecho
            entre todos. Explorá, guardá tus favoritos y sumá los que faltan.
          </p>
          <div className="mt-8 flex flex-wrap justify-center gap-3">
            <Link
              href="/mapa"
              className="rounded-full bg-brand px-6 py-3 font-semibold text-white hover:bg-brand-dark"
            >
              Ver el mapa
            </Link>
            <Link
              href="/lugares"
              className="rounded-full border border-white/40 px-6 py-3 font-semibold text-white hover:bg-white/10"
            >
              Explorar lugares
            </Link>
          </div>
        </div>
      </section>

      {/* Sobre */}
      <section className="mx-auto grid max-w-6xl items-center gap-10 px-4 py-20 md:grid-cols-2">
        <div className="relative aspect-[4/3] overflow-hidden rounded-3xl">
          <Image src="/img/about.jpg" alt="Sobre Catamap" fill className="object-cover" />
        </div>
        <div>
          <p className="text-sm font-semibold uppercase tracking-wide text-brand">Sobre nosotros</p>
          <h2 className="mt-2 font-heading text-3xl font-bold">
            Descentralizar el turismo, potenciar lo local
          </h2>
          <p className="mt-4 text-muted-foreground">
            Catamap visibiliza atractivos poco convencionales de toda la provincia y fomenta la
            participación de la comunidad. Cualquiera puede proponer un lugar; un equipo de
            moderación lo revisa antes de publicarlo en el mapa.
          </p>
          <div className="mt-6 flex gap-3">
            <Image src="/img/bicicta.jpg" alt="" width={140} height={100} className="rounded-xl object-cover" />
            <Image src="/img/vistacta.jpg" alt="" width={140} height={100} className="rounded-xl object-cover" />
          </div>
        </div>
      </section>

      {/* Galería */}
      <section className="bg-[#1c1207] py-16 text-white">
        <div className="mx-auto max-w-6xl px-4">
          <h2 className="text-center font-heading text-3xl font-bold">Lugares destacados de Catamarca</h2>
          <div className="mt-10 grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4">
            {GALLERY.map((img) => (
              <div key={img} className="relative aspect-square overflow-hidden rounded-xl">
                <Image
                  src={`/img-catamarca/${img}`}
                  alt=""
                  fill
                  sizes="(max-width:640px) 50vw, 25vw"
                  className="object-cover transition hover:scale-110"
                />
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Destinos */}
      <section className="mx-auto max-w-6xl px-4 py-20">
        <div className="mb-10 text-center">
          <p className="text-sm font-semibold uppercase tracking-wide text-brand">Destinos</p>
          <h2 className="mt-2 font-heading text-3xl font-bold">Para empezar a recorrer</h2>
        </div>
        <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {destinos.map((l) => (
            <LugarCard
              key={l.id}
              isAuthenticated={!!session}
              isFavorito={favSet.has(l.id)}
              lugar={{
                id: l.id,
                nombre: l.nombre,
                descripcion: l.descripcion,
                imagen: l.imagen,
                categoria: l.categoria?.nombre ?? null,
                departamento: l.departamento?.nombre ?? null,
              }}
            />
          ))}
        </div>
      </section>

      {/* Servicios */}
      <section className="bg-secondary py-20">
        <div className="mx-auto grid max-w-6xl gap-6 px-4 md:grid-cols-3">
          {[
            { icon: Compass, t: "Explorá Catamarca", d: "Recorré el mapa filtrando por categoría y departamento." },
            { icon: MessagesSquare, t: "Conectá con viajeros", d: "Seguí perfiles, dejá opiniones y compartí experiencias." },
            { icon: Star, t: "Opiná y guardá favoritos", d: "Valorá los lugares que visitaste y armá tu lista." },
          ].map(({ icon: Icon, t, d }) => (
            <div key={t} className="rounded-2xl bg-card p-6 shadow-sm">
              <div className="grid size-12 place-items-center rounded-xl bg-brand/10 text-brand">
                <Icon className="size-6" />
              </div>
              <h3 className="mt-4 font-heading text-lg font-semibold">{t}</h3>
              <p className="mt-1 text-sm text-muted-foreground">{d}</p>
            </div>
          ))}
        </div>
      </section>

      {/* CTA */}
      <section className="relative isolate overflow-hidden py-20 text-white">
        <Image src="/img/cuestaportezuelo.jpg" alt="" fill className="-z-10 object-cover brightness-[0.4]" />
        <div className="mx-auto max-w-3xl px-4 text-center">
          <MapPinned className="mx-auto size-10 text-brand" />
          <h2 className="mt-4 font-heading text-3xl font-bold">¿Conocés un lugar que falta en el mapa?</h2>
          <p className="mt-3 text-white/85">
            Registrate gratis y sumá tu aporte a Catamap. Cada sugerencia ayuda a mostrar más de la
            provincia.
          </p>
          <div className="mt-6">
            <HomeCtaButton isAuthenticated={!!session} />
          </div>
        </div>
      </section>
    </>
  );
}
