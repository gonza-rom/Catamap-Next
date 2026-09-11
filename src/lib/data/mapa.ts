import { unstable_cache } from "next/cache";
import { prisma } from "@/lib/prisma";

export type MapaLugar = {
  id: number;
  nombre: string;
  descripcion: string | null;
  direccion: string | null;
  lat: number;
  lng: number;
  imagen: string | null;
  categoria: string;
  departamento: string;
};

async function fetchMapaLugares(): Promise<MapaLugar[]> {
  const lugares = await prisma.lugar.findMany({
    where: { estado: "aprobado", lat: { not: null }, lng: { not: null } },
    select: {
      id: true,
      nombre: true,
      descripcion: true,
      direccion: true,
      lat: true,
      lng: true,
      imagen: true,
      categoria: { select: { nombre: true } },
      departamento: { select: { nombre: true } },
    },
  });

  return lugares.map((l) => ({
    id: l.id,
    nombre: l.nombre,
    descripcion: l.descripcion,
    direccion: l.direccion,
    lat: l.lat!,
    lng: l.lng!,
    imagen: l.imagen,
    categoria: l.categoria?.nombre ?? "Otros",
    departamento: (l.departamento?.nombre ?? "DESCONOCIDO").toUpperCase(),
  }));
}

/** Los ~1400 lugares del mapa. Es la consulta más pesada del sitio — se cachea 2 min
 *  (se invalida antes si se aprueba/edita un lugar desde el admin). */
export const getMapaLugares = unstable_cache(fetchMapaLugares, ["mapa-lugares"], {
  tags: ["lugares"],
  revalidate: 120,
});
