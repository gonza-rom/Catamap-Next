import { prisma } from "@/lib/prisma";
import { DepartamentosAdminTable } from "@/components/admin/departamentos-admin-table";

export default async function AdminDepartamentosPage() {
  const departamentos = await prisma.departamento.findMany({
    include: { _count: { select: { lugares: true } } },
    orderBy: { nombre: "asc" },
  });

  return (
    <div>
      <h1 className="mb-4 font-heading text-2xl font-bold">Departamentos ({departamentos.length})</h1>
      <DepartamentosAdminTable
        departamentos={departamentos.map((d) => ({ id: d.id, nombre: d.nombre, totalLugares: d._count.lugares }))}
      />
    </div>
  );
}
