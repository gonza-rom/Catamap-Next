"use client";

import { useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { Pencil, Plus, Trash2 } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { CategoryIcon } from "@/components/category-icon";
import { adminCrearCategoria, adminActualizarCategoria, adminEliminarCategoria } from "@/lib/actions/admin";

type Cat = { id: number; nombre: string; descripcion: string | null; totalLugares: number };

export function CategoriasAdminTable({ categorias }: { categorias: Cat[] }) {
  const router = useRouter();
  const [editing, setEditing] = useState<Cat | "new" | null>(null);
  const [pending, start] = useTransition();

  return (
    <div className="space-y-4">
      <button
        onClick={() => setEditing("new")}
        className="inline-flex items-center gap-1 rounded-full bg-admin px-4 py-2 text-sm font-medium text-white"
      >
        <Plus className="size-4" /> Nueva categoría
      </button>

      <div className="overflow-x-auto rounded-xl border bg-card">
        <table className="w-full text-sm">
          <thead className="bg-muted/50 text-left text-xs uppercase text-muted-foreground">
            <tr>
              <th className="p-3">Icono</th>
              <th className="p-3">Nombre</th>
              <th className="p-3">Descripción</th>
              <th className="p-3">Lugares</th>
              <th className="p-3 text-right">Acciones</th>
            </tr>
          </thead>
          <tbody>
            {categorias.map((c) => (
              <tr key={c.id} className="border-t">
                <td className="p-3">
                  <span className="grid size-8 place-items-center rounded-lg bg-admin/10 text-admin">
                    <CategoryIcon nombre={c.nombre} className="size-4" />
                  </span>
                </td>
                <td className="p-3 font-medium">{c.nombre}</td>
                <td className="p-3 text-muted-foreground">{c.descripcion || "—"}</td>
                <td className="p-3">{c.totalLugares}</td>
                <td className="p-3 text-right">
                  <button onClick={() => setEditing(c)} className="mr-2 text-muted-foreground hover:text-foreground">
                    <Pencil className="size-4" />
                  </button>
                  <button
                    disabled={pending}
                    onClick={() =>
                      start(async () => {
                        if (c.totalLugares > 0) {
                          toast.error(`No se puede eliminar: tiene ${c.totalLugares} lugares asociados`);
                          return;
                        }
                        if (!confirm(`¿Eliminar "${c.nombre}"?`)) return;
                        const res = await adminEliminarCategoria(c.id);
                        if (res.ok) {
                          toast.success("Categoría eliminada");
                          router.refresh();
                        } else toast.error(res.error);
                      })
                    }
                    className="text-muted-foreground hover:text-red-500"
                  >
                    <Trash2 className="size-4" />
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <Dialog open={!!editing} onOpenChange={(o) => !o && setEditing(null)}>
        <DialogContent>
          <DialogHeader><DialogTitle>{editing === "new" ? "Nueva categoría" : "Editar categoría"}</DialogTitle></DialogHeader>
          {editing && (
            <CategoriaForm
              categoria={editing === "new" ? null : editing}
              onDone={() => {
                setEditing(null);
                router.refresh();
              }}
            />
          )}
        </DialogContent>
      </Dialog>
    </div>
  );
}

function CategoriaForm({ categoria, onDone }: { categoria: Cat | null; onDone: () => void }) {
  const [nombre, setNombre] = useState(categoria?.nombre ?? "");
  const [descripcion, setDescripcion] = useState(categoria?.descripcion ?? "");
  const [pending, start] = useTransition();

  return (
    <div className="space-y-4">
      <div className="space-y-1.5">
        <Label>Nombre</Label>
        <div className="flex items-center gap-2">
          <span className="grid size-10 shrink-0 place-items-center rounded-lg bg-admin/10 text-admin">
            <CategoryIcon nombre={nombre || "otros"} className="size-5" />
          </span>
          <Input value={nombre} onChange={(e) => setNombre(e.target.value)} placeholder="Ej: Mirador" />
        </div>
        <p className="text-xs text-muted-foreground">El ícono se elige automáticamente según el nombre.</p>
      </div>
      <div className="space-y-1.5">
        <Label>Descripción</Label>
        <Textarea value={descripcion} onChange={(e) => setDescripcion(e.target.value)} rows={2} />
      </div>
      <DialogFooter>
        <button
          disabled={pending || !nombre.trim()}
          onClick={() =>
            start(async () => {
              const res = categoria
                ? await adminActualizarCategoria(categoria.id, { nombre, descripcion })
                : await adminCrearCategoria({ nombre, descripcion });
              if (res.ok) {
                toast.success(categoria ? "Categoría actualizada" : "Categoría creada");
                onDone();
              } else toast.error(res.error);
            })
          }
          className="rounded-full bg-admin px-5 py-2 text-sm font-medium text-white disabled:opacity-60"
        >
          Guardar
        </button>
      </DialogFooter>
    </div>
  );
}
