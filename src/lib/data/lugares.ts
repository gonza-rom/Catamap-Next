import { prisma } from "@/lib/prisma";
import type { Prisma } from "@/generated/prisma";

export const PAGE_SIZE = 12;

export type LugaresFilter = {
  categoria?: number;
  departamento?: string;
  nombre?: string;
  page?: number;
};

export async function getLugaresPage(filter: LugaresFilter) {
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
      include: { categoria: true, departamento: true },
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

export async function getFiltros() {
  const [categorias, departamentos] = await Promise.all([
    prisma.categoria.findMany({ orderBy: { nombre: "asc" } }),
    prisma.departamento.findMany({ orderBy: { nombre: "asc" } }),
  ]);
  return { categorias, departamentos };
}

/** IDs de lugares favoritos del usuario (Set vacío si no hay sesión). */
export async function getFavoritoIds(userId: string | undefined): Promise<Set<number>> {
  if (!userId) return new Set();
  const favs = await prisma.favorito.findMany({
    where: { idUsuario: userId },
    select: { idLugar: true },
  });
  return new Set(favs.map((f) => f.idLugar));
}
