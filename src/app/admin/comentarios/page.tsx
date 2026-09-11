import { prisma } from "@/lib/prisma";
import type { Prisma } from "@/generated/prisma";
import { ComentariosAdminTable } from "@/components/admin/comentarios-admin-table";

const PAGE_SIZE = 20;
type SP = Promise<{ estado?: string; page?: string }>;

export default async function AdminComentariosPage({ searchParams }: { searchParams: SP }) {
  const sp = await searchParams;
  const page = Number(sp.page ?? 1);
  const where: Prisma.ComentarioWhereInput = sp.estado ? { estado: sp.estado as never } : {};

  const [total, comentarios] = await Promise.all([
    prisma.comentario.count({ where }),
    prisma.comentario.findMany({
      where,
      include: { usuario: { select: { nombre: true } }, lugar: { select: { nombre: true } } },
      orderBy: { fechaCreacion: "desc" },
      skip: (page - 1) * PAGE_SIZE,
      take: PAGE_SIZE,
    }),
  ]);

  return (
    <div>
      <h1 className="mb-4 font-heading text-2xl font-bold">Comentarios ({total})</h1>
      <ComentariosAdminTable
        estado={sp.estado}
        page={page}
        totalPages={Math.max(1, Math.ceil(total / PAGE_SIZE))}
        comentarios={comentarios.map((c) => ({
          id: c.id,
          usuarioNombre: c.usuario.nombre,
          lugarNombre: c.lugar.nombre,
          comentario: c.comentario,
          estado: c.estado,
          fecha: c.fechaCreacion.toISOString(),
        }))}
      />
    </div>
  );
}
