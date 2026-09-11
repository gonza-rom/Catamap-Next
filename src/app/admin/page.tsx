import { Users, MapPin, Inbox, MessageSquare } from "lucide-react";
import { prisma } from "@/lib/prisma";
import { fechaHora } from "@/lib/format";

export default async function AdminDashboard() {
  const [usuarios, lugares, sugerencias, comentarios, actividadUsuarios, actividadLugares, actividadComentarios, activos] =
    await Promise.all([
      prisma.perfil.groupBy({ by: ["estado"], _count: true }),
      prisma.lugar.groupBy({ by: ["estado"], _count: true }),
      prisma.lugarSugerido.count({ where: { estado: "pendiente" } }),
      prisma.comentario.groupBy({ by: ["estado"], _count: true }),
      prisma.perfil.findMany({ orderBy: { fechaRegistro: "desc" }, take: 5, select: { nombre: true, fechaRegistro: true } }),
      prisma.lugar.findMany({ orderBy: { id: "desc" }, take: 5, select: { nombre: true, createdAt: true } }),
      prisma.comentario.findMany({
        orderBy: { fechaCreacion: "desc" },
        take: 5,
        include: { lugar: { select: { nombre: true } } },
      }),
      prisma.perfil.findMany({
        take: 5,
        orderBy: { comentarios: { _count: "desc" } },
        select: { nombre: true, rol: true, _count: { select: { comentarios: true } } },
      }),
    ]);

  const count = (arr: { estado: string; _count: number }[], estado: string) =>
    arr.find((a) => a.estado === estado)?._count ?? 0;
  const totalUsuarios = usuarios.reduce((a, b) => a + b._count, 0);
  const totalLugares = lugares.reduce((a, b) => a + b._count, 0);
  const totalComentarios = comentarios.reduce((a, b) => a + b._count, 0);

  const actividad = [
    ...actividadUsuarios.map((u) => ({ tipo: "usuario", desc: `Nuevo usuario: ${u.nombre}`, fecha: u.fechaRegistro })),
    ...actividadLugares.map((l) => ({ tipo: "lugar", desc: `Nuevo lugar: ${l.nombre}`, fecha: l.createdAt })),
    ...actividadComentarios.map((c) => ({
      tipo: "comentario",
      desc: `Nuevo comentario en ${c.lugar.nombre}`,
      fecha: c.fechaCreacion,
    })),
  ]
    .sort((a, b) => +new Date(b.fecha) - +new Date(a.fecha))
    .slice(0, 10);

  const iconos: Record<string, string> = { usuario: "👤", lugar: "📍", comentario: "💬" };

  return (
    <div className="space-y-6">
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard icon={Users} label="Total usuarios" value={totalUsuarios} sub={`${count(usuarios, "activo")} activos`} />
        <StatCard icon={MapPin} label="Lugares turísticos" value={totalLugares} sub={`${count(lugares, "pendiente")} pendientes`} />
        <StatCard icon={Inbox} label="Sugerencias pendientes" value={sugerencias} sub="por revisar" />
        <StatCard icon={MessageSquare} label="Comentarios" value={totalComentarios} sub={`${count(comentarios, "pendiente")} pendientes`} />
      </div>

      <div className="grid gap-4 lg:grid-cols-2">
        <div className="rounded-2xl border bg-card p-5">
          <h2 className="mb-3 font-heading font-semibold">Actividad reciente</h2>
          <ul className="space-y-2">
            {actividad.map((a, i) => (
              <li key={i} className="flex items-center gap-2 border-b pb-2 text-sm last:border-0">
                <span>{iconos[a.tipo]}</span>
                <span className="flex-1">{a.desc}</span>
                <span className="text-xs text-muted-foreground">{fechaHora(a.fecha)}</span>
              </li>
            ))}
          </ul>
        </div>
        <div className="rounded-2xl border bg-card p-5">
          <h2 className="mb-3 font-heading font-semibold">Usuarios más activos</h2>
          <ul className="space-y-2">
            {activos.map((u, i) => (
              <li key={i} className="flex items-center justify-between border-b pb-2 text-sm last:border-0">
                <span>{u.nombre}</span>
                <span className="text-xs capitalize text-muted-foreground">
                  {u._count.comentarios} comentarios · {u.rol}
                </span>
              </li>
            ))}
          </ul>
        </div>
      </div>
    </div>
  );
}

function StatCard({
  icon: Icon,
  label,
  value,
  sub,
}: {
  icon: React.ComponentType<{ className?: string }>;
  label: string;
  value: number;
  sub: string;
}) {
  return (
    <div className="rounded-2xl border bg-card p-5">
      <div className="flex items-center gap-3">
        <div className="grid size-10 place-items-center rounded-xl bg-admin/10 text-admin">
          <Icon className="size-5" />
        </div>
        <div>
          <p className="text-2xl font-bold">{value}</p>
          <p className="text-xs text-muted-foreground">{label}</p>
        </div>
      </div>
      <p className="mt-2 text-xs text-muted-foreground">{sub}</p>
    </div>
  );
}
