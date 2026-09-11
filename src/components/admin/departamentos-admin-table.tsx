"use client";

import { useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { Pencil, Trash2, Check, X } from "lucide-react";
import { Input } from "@/components/ui/input";
import { adminActualizarDepartamento, adminEliminarDepartamento } from "@/lib/actions/admin";

type Dep = { id: number; nombre: string; totalLugares: number };

export function DepartamentosAdminTable({ departamentos }: { departamentos: Dep[] }) {
  const router = useRouter();
  const [editingId, setEditingId] = useState<number | null>(null);
  const [nombre, setNombre] = useState("");
  const [pending, start] = useTransition();

  return (
    <div className="overflow-x-auto rounded-xl border bg-card">
      <table className="w-full text-sm">
        <thead className="bg-muted/50 text-left text-xs uppercase text-muted-foreground">
          <tr>
            <th className="p-3">Nombre</th>
            <th className="p-3">Lugares</th>
            <th className="p-3 text-right">Acciones</th>
          </tr>
        </thead>
        <tbody>
          {departamentos.map((d) => (
            <tr key={d.id} className="border-t">
              <td className="p-3 font-medium">
                {editingId === d.id ? (
                  <Input value={nombre} onChange={(e) => setNombre(e.target.value)} className="h-8 w-48" />
                ) : (
                  d.nombre
                )}
              </td>
              <td className="p-3">{d.totalLugares}</td>
              <td className="space-x-2 p-3 text-right">
                {editingId === d.id ? (
                  <>
                    <button
                      disabled={pending}
                      onClick={() =>
                        start(async () => {
                          const res = await adminActualizarDepartamento(d.id, nombre);
                          if (res.ok) {
                            toast.success("Actualizado");
                            setEditingId(null);
                            router.refresh();
                          } else toast.error(res.error);
                        })
                      }
                      className="text-green-600"
                    >
                      <Check className="inline size-4" />
                    </button>
                    <button onClick={() => setEditingId(null)} className="text-muted-foreground">
                      <X className="inline size-4" />
                    </button>
                  </>
                ) : (
                  <>
                    <button
                      onClick={() => {
                        setEditingId(d.id);
                        setNombre(d.nombre);
                      }}
                      className="mr-1 text-muted-foreground hover:text-foreground"
                    >
                      <Pencil className="inline size-4" />
                    </button>
                    <button
                      disabled={pending}
                      onClick={() =>
                        start(async () => {
                          if (d.totalLugares > 0) {
                            toast.error(`No se puede eliminar: tiene ${d.totalLugares} lugares asociados`);
                            return;
                          }
                          if (!confirm(`¿Eliminar "${d.nombre}"?`)) return;
                          const res = await adminEliminarDepartamento(d.id);
                          if (res.ok) {
                            toast.success("Eliminado");
                            router.refresh();
                          } else toast.error(res.error);
                        })
                      }
                      className="text-muted-foreground hover:text-red-500"
                    >
                      <Trash2 className="inline size-4" />
                    </button>
                  </>
                )}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
