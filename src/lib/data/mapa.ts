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

export async function getMapaLugares(): Promise<MapaLugar[]> {
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
