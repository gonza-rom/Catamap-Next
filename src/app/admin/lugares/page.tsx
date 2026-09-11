import { prisma } from "@/lib/prisma";
import type { Prisma } from "@/generated/prisma";
import { LugaresAdminTable } from "@/components/admin/lugares-admin-table";

const PAGE_SIZE = 20;
type SP = Promise<{ q?: string; estado?: string; page?: string }>;

export default async function AdminLugaresPage({ searchParams }: { searchParams: SP }) {
  const sp = await searchParams;
  const page = Number(sp.page ?? 1);

  const where: Prisma.LugarWhereInput = {};
  if (sp.estado) where.estado = sp.estado as never;
  if (sp.q) where.nombre = { contains: sp.q, mode: "insensitive" };

  const [total, lugares, categorias, departamentos] = await Promise.all([
    prisma.lugar.count({ where }),
    prisma.lugar.findMany({
      where,
      include: {
        categoria: true,
        departamento: true,
        _count: { select: { favoritos: true, comentarios: true } },
      },
      orderBy: { id: "desc" },
      skip: (page - 1) * PAGE_SIZE,
      take: PAGE_SIZE,
    }),
    prisma.categoria.findMany({ orderBy: { nombre: "asc" } }),
    prisma.departamento.findMany({ orderBy: { nombre: "asc" } }),
  ]);

  return (
    <div>
      <h1 className="mb-4 font-heading text-2xl font-bold">Lugares turísticos ({total})</h1>
      <LugaresAdminTable
        lugares={lugares.map((l) => ({
          id: l.id,
          nombre: l.nombre,
          imagen: l.imagen,
          estado: l.estado,
          categoria: l.categoria?.nombre ?? "—",
          departamento: l.departamento?.nombre ?? "—",
          idCategoria: l.idCategoria,
          idDepartamento: l.idDepartamento,
          favoritos: l._count.favoritos,
          comentarios: l._count.comentarios,
        }))}
        categorias={categorias.map((c) => ({ id: c.idCategoria, nombre: c.nombre }))}
        departamentos={departamentos.map((d) => ({ id: d.id, nombre: d.nombre }))}
        page={page}
        totalPages={Math.max(1, Math.ceil(total / PAGE_SIZE))}
        filtros={{ q: sp.q, estado: sp.estado }}
      />
    </div>
  );
}
