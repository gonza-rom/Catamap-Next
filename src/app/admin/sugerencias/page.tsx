import { prisma } from "@/lib/prisma";
import { SugerenciasAdminTable } from "@/components/admin/sugerencias-admin-table";

type SP = Promise<{ estado?: string }>;

export default async function AdminSugerenciasPage({ searchParams }: { searchParams: SP }) {
  const sp = await searchParams;
  const estado = (sp.estado ?? "pendiente") as "pendiente" | "aprobado" | "rechazado";

  const sugerencias = await prisma.lugarSugerido.findMany({
    where: { estado },
    include: {
      usuario: { select: { id: true, nombre: true } },
      categoria: true,
      departamento: true,
    },
    orderBy: { fechaSugerido: "desc" },
  });

  return (
    <div>
      <h1 className="mb-4 font-heading text-2xl font-bold">Lugares sugeridos</h1>
      <SugerenciasAdminTable
        estado={estado}
        sugerencias={sugerencias.map((s) => ({
          id: s.id,
          nombre: s.nombre,
          imagen: s.imagen,
          usuarioNombre: s.usuario.nombre,
          categoria: s.categoria?.nombre ?? "—",
          departamento: s.departamento?.nombre ?? "—",
          fecha: s.fechaSugerido.toISOString(),
        }))}
      />
    </div>
  );
}
