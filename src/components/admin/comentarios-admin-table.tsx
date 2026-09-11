"use client";

import { useTransition } from "react";
import { useRouter, usePathname, useSearchParams } from "next/navigation";
import { toast } from "sonner";
import { Check, X, Trash2 } from "lucide-react";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { fecha } from "@/lib/format";
import { adminCambiarEstadoComentario, adminEliminarComentario } from "@/lib/actions/admin";
import { AdminPagination } from "./admin-pagination";

type C = { id: number; usuarioNombre: string; lugarNombre: string; comentario: string; estado: string; fecha: string };
const ALL = "__all__";
const badge: Record<string, string> = {
  aprobado: "bg-green-100 text-green-700",
  pendiente: "bg-amber-100 text-amber-700",
  rechazado: "bg-red-100 text-red-700",
};

export function ComentariosAdminTable({
  comentarios,
  estado,
  page,
  totalPages,
}: {
  comentarios: C[];
  estado?: string;
  page: number;
  totalPages: number;
}) {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const [pending, start] = useTransition();

  function setFiltro(v: string) {
    const next = new URLSearchParams(params.toString());
    if (v === ALL) next.delete("estado");
    else next.set("estado", v);
    next.delete("page");
    router.push(`${pathname}?${next.toString()}`);
  }

  return (
    <div className="space-y-4">
      <Select value={estado ?? ALL} onValueChange={setFiltro}>
        <SelectTrigger className="w-44"><SelectValue placeholder="Estado" /></SelectTrigger>
        <SelectContent>
          <SelectItem value={ALL}>Todos</SelectItem>
          <SelectItem value="pendiente">Pendientes</SelectItem>
          <SelectItem value="aprobado">Aprobados</SelectItem>
          <SelectItem value="rechazado">Rechazados</SelectItem>
        </SelectContent>
      </Select>

      <div className="overflow-x-auto rounded-xl border bg-card">
        <table className="w-full text-sm">
          <thead className="bg-muted/50 text-left text-xs uppercase text-muted-foreground">
            <tr>
              <th className="p-3">Usuario</th>
              <th className="p-3">Lugar</th>
              <th className="p-3">Comentario</th>
              <th className="p-3">Estado</th>
              <th className="p-3">Fecha</th>
              <th className="p-3 text-right">Acciones</th>
            </tr>
          </thead>
          <tbody>
            {comentarios.map((c) => (
              <tr key={c.id} className="border-t align-top">
                <td className="p-3">{c.usuarioNombre}</td>
                <td className="p-3">{c.lugarNombre}</td>
                <td className="max-w-xs truncate p-3">{c.comentario}</td>
                <td className="p-3">
                  <span className={`rounded-full px-2 py-0.5 text-xs capitalize ${badge[c.estado]}`}>{c.estado}</span>
                </td>
                <td className="p-3 text-xs text-muted-foreground">{fecha(c.fecha)}</td>
                <td className="space-x-2 p-3 text-right">
                  {c.estado !== "aprobado" && (
                    <button
                      disabled={pending}
                      onClick={() =>
                        start(async () => {
                          await adminCambiarEstadoComentario(c.id, "aprobado");
                          toast.success("Aprobado");
                          router.refresh();
                        })
                      }
                      className="text-green-600 hover:text-green-700"
                    >
                      <Check className="inline size-4" />
                    </button>
                  )}
                  {c.estado !== "rechazado" && (
                    <button
                      disabled={pending}
                      onClick={() =>
                        start(async () => {
                          await adminCambiarEstadoComentario(c.id, "rechazado");
                          toast.success("Rechazado");
                          router.refresh();
                        })
                      }
                      className="text-red-500 hover:text-red-600"
                    >
                      <X className="inline size-4" />
                    </button>
                  )}
                  <button
                    disabled={pending}
                    onClick={() =>
                      start(async () => {
                        if (!confirm("¿Eliminar comentario?")) return;
                        await adminEliminarComentario(c.id);
                        toast.success("Eliminado");
                        router.refresh();
                      })
                    }
                    className="text-muted-foreground hover:text-red-500"
                  >
                    <Trash2 className="inline size-4" />
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
      <AdminPagination page={page} totalPages={totalPages} />
    </div>
  );
}
