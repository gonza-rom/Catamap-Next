import { unstable_cache } from "next/cache";
import { prisma } from "@/lib/prisma";
import type { Prisma } from "@/generated/prisma";

export const PAGE_SIZE = 12;

export type LugaresFilter = {
  categoria?: number;
  departamento?: string;
  nombre?: string;
  page?: number;
};

async function fetchLugaresPage(filter: LugaresFilter) {
  const page = Math.max(1, filter.page ?? 1);
  const where: Prisma.LugarWhereInput = { estado: "aprobado" };

  if (filter.categoria) where.idCategoria = filter.categoria;
  if (filter.departamento)
    where.departamento = { is: { nombre: { equals: filter.departamento, mode: "insensitive" } } };
  if (filter.nombre) where.nombre = { contains: filter.nombre, mode: "insensitive" };

  const [total, lugares] = await Promise.all([
    prisma.lugar.count({ where }),
    prisma.lugar.findMany({
      where,
      select: {
        id: true,
        nombre: true,
        descripcion: true,
        imagen: true,
        categoria: { select: { nombre: true } },
        departamento: { select: { nombre: true } },
      },
      orderBy: { nombre: "asc" },
      skip: (page - 1) * PAGE_SIZE,
      take: PAGE_SIZE,
    }),
  ]);

  return {
    lugares,
    total,
    page,
    totalPages: Math.max(1, Math.ceil(total / PAGE_SIZE)),
  };
}

/** Catálogo de lugares aprobados, paginado y filtrado. Se cachea 60s por combinación de filtros
 *  (evita ir a la base en cada navegación) y se invalida al tocar un lugar desde el admin. */
export const getLugaresPage = unstable_cache(fetchLugaresPage, ["lugares-page"], {
  tags: ["lugares"],
  revalidate: 60,
});

async function fetchFiltros() {
  const [categorias, departamentos] = await Promise.all([
    prisma.categoria.findMany({ orderBy: { nombre: "asc" } }),
    prisma.departamento.findMany({ orderBy: { nombre: "asc" } }),
  ]);
  return { categorias, departamentos };
}

/** Categorías y departamentos para selects/filtros. Cambian poco — se cachean 5 min. */
export const getFiltros = unstable_cache(fetchFiltros, ["filtros"], {
  tags: ["categorias", "departamentos"],
  revalidate: 300,
});

/** IDs de lugares favoritos del usuario (Set vacío si no hay sesión). Depende de la sesión: nunca se cachea. */
export async function getFavoritoIds(userId: string | undefined): Promise<Set<number>> {
  if (!userId) return new Set();
  const favs = await prisma.favorito.findMany({
    where: { idUsuario: userId },
    select: { idLugar: true },
  });
  return new Set(favs.map((f) => f.idLugar));
}
