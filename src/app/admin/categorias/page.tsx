import { prisma } from "@/lib/prisma";
import { CategoriasAdminTable } from "@/components/admin/categorias-admin-table";

export default async function AdminCategoriasPage() {
  const categorias = await prisma.categoria.findMany({
    include: { _count: { select: { lugares: true } } },
    orderBy: { nombre: "asc" },
  });

  return (
    <div>
      <h1 className="mb-4 font-heading text-2xl font-bold">Categorías ({categorias.length})</h1>
      <CategoriasAdminTable
        categorias={categorias.map((c) => ({
          id: c.idCategoria,
          nombre: c.nombre,
          descripcion: c.descripcion,
          icono: c.icono,
          totalLugares: c._count.lugares,
        }))}
      />
    </div>
  );
}
