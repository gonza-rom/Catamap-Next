import { prisma } from "@/lib/prisma";
import type { Prisma } from "@/generated/prisma";
import { UsuariosTable } from "@/components/admin/usuarios-table";

const PAGE_SIZE = 20;
type SP = Promise<{ q?: string; rol?: string; estado?: string; page?: string }>;

export default async function AdminUsuariosPage({ searchParams }: { searchParams: SP }) {
  const sp = await searchParams;
  const page = Number(sp.page ?? 1);

  const where: Prisma.PerfilWhereInput = {};
  if (sp.rol) where.rol = sp.rol as never;
  if (sp.estado) where.estado = sp.estado as never;
  if (sp.q) where.nombre = { contains: sp.q, mode: "insensitive" };

  const [total, usuarios] = await Promise.all([
    prisma.perfil.count({ where }),
    prisma.perfil.findMany({
      where,
      orderBy: { fechaRegistro: "desc" },
      skip: (page - 1) * PAGE_SIZE,
      take: PAGE_SIZE,
    }),
  ]);

  // emails viven en auth.users — se obtienen por separado si hace falta; se omiten acá por simplicidad.
  return (
    <div>
      <h1 className="mb-4 font-heading text-2xl font-bold">Usuarios ({total})</h1>
      <UsuariosTable
        usuarios={usuarios.map((u) => ({
          id: u.id,
          nombre: u.nombre,
          rol: u.rol,
          estado: u.estado,
          telefono: u.telefono,
          fechaRegistro: u.fechaRegistro.toISOString(),
        }))}
        page={page}
        totalPages={Math.max(1, Math.ceil(total / PAGE_SIZE))}
        filtros={{ q: sp.q, rol: sp.rol, estado: sp.estado }}
      />
    </div>
  );
}
