"use client";

import { useState, useTransition } from "react";
import { useRouter, usePathname, useSearchParams } from "next/navigation";
import { toast } from "sonner";
import { Pencil, Trash2 } from "lucide-react";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
} from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { fecha } from "@/lib/format";
import { adminActualizarUsuario, adminEliminarUsuario } from "@/lib/actions/admin";
import { AdminPagination } from "./admin-pagination";

type Usuario = {
  id: string;
  nombre: string;
  rol: string;
  estado: string;
  telefono: string | null;
  fechaRegistro: string;
};

const ALL = "__all__";

const badgeRol: Record<string, string> = {
  admin: "bg-indigo-100 text-indigo-700",
  emprendedor: "bg-blue-100 text-blue-700",
  usuario: "bg-gray-100 text-gray-700",
};
const badgeEstado: Record<string, string> = {
  activo: "bg-green-100 text-green-700",
  suspendido: "bg-amber-100 text-amber-700",
  inactivo: "bg-gray-100 text-gray-500",
};

export function UsuariosTable({
  usuarios,
  page,
  totalPages,
  filtros,
}: {
  usuarios: Usuario[];
  page: number;
  totalPages: number;
  filtros: { q?: string; rol?: string; estado?: string };
}) {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const [editing, setEditing] = useState<Usuario | null>(null);
  const [pending, start] = useTransition();

  function updateParam(key: string, value: string | null) {
    const next = new URLSearchParams(params.toString());
    if (value) next.set(key, value);
    else next.delete(key);
    next.delete("page");
    router.push(`${pathname}?${next.toString()}`);
  }

  return (
    <div className="space-y-4">
      <div className="flex flex-wrap gap-2">
        <Input
          placeholder="Buscar por nombre…"
          defaultValue={filtros.q}
          onKeyDown={(e) => e.key === "Enter" && updateParam("q", (e.target as HTMLInputElement).value)}
          className="w-56"
        />
        <Select value={filtros.rol ?? ALL} onValueChange={(v) => updateParam("rol", v === ALL ? null : v)}>
          <SelectTrigger className="w-40"><SelectValue placeholder="Rol" /></SelectTrigger>
          <SelectContent>
            <SelectItem value={ALL}>Todos los roles</SelectItem>
            <SelectItem value="usuario">Usuario</SelectItem>
            <SelectItem value="emprendedor">Emprendedor</SelectItem>
            <SelectItem value="admin">Admin</SelectItem>
          </SelectContent>
        </Select>
        <Select value={filtros.estado ?? ALL} onValueChange={(v) => updateParam("estado", v === ALL ? null : v)}>
          <SelectTrigger className="w-40"><SelectValue placeholder="Estado" /></SelectTrigger>
          <SelectContent>
            <SelectItem value={ALL}>Todos los estados</SelectItem>
            <SelectItem value="activo">Activo</SelectItem>
            <SelectItem value="suspendido">Suspendido</SelectItem>
            <SelectItem value="inactivo">Inactivo</SelectItem>
          </SelectContent>
        </Select>
      </div>

      <div className="overflow-x-auto rounded-xl border bg-card">
        <table className="w-full text-sm">
          <thead className="bg-muted/50 text-left text-xs uppercase text-muted-foreground">
            <tr>
              <th className="p-3">Nombre</th>
              <th className="p-3">Rol</th>
              <th className="p-3">Estado</th>
              <th className="p-3">Registro</th>
              <th className="p-3 text-right">Acciones</th>
            </tr>
          </thead>
          <tbody>
            {usuarios.map((u) => (
              <tr key={u.id} className="border-t">
                <td className="p-3 font-medium">{u.nombre}</td>
                <td className="p-3">
                  <span className={`rounded-full px-2 py-0.5 text-xs capitalize ${badgeRol[u.rol]}`}>{u.rol}</span>
                </td>
                <td className="p-3">
                  <span className={`rounded-full px-2 py-0.5 text-xs capitalize ${badgeEstado[u.estado]}`}>{u.estado}</span>
                </td>
                <td className="p-3 text-muted-foreground">{fecha(u.fechaRegistro)}</td>
                <td className="p-3 text-right">
                  <button onClick={() => setEditing(u)} className="mr-2 text-muted-foreground hover:text-foreground">
                    <Pencil className="size-4" />
                  </button>
                  <button
                    onClick={() =>
                      start(async () => {
                        if (!confirm(`¿Eliminar a ${u.nombre}?`)) return;
                        const res = await adminEliminarUsuario(u.id);
                        if (res.ok) {
                          toast.success("Usuario eliminado");
                          router.refresh();
                        } else toast.error(res.error);
                      })
                    }
                    disabled={pending}
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

      <AdminPagination page={page} totalPages={totalPages} />

      <Dialog open={!!editing} onOpenChange={(o) => !o && setEditing(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Editar usuario</DialogTitle>
          </DialogHeader>
          {editing && (
            <EditUsuarioForm
              usuario={editing}
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

function EditUsuarioForm({ usuario, onDone }: { usuario: Usuario; onDone: () => void }) {
  const [nombre, setNombre] = useState(usuario.nombre);
  const [rol, setRol] = useState(usuario.rol);
  const [estado, setEstado] = useState(usuario.estado);
  const [pending, start] = useTransition();

  return (
    <div className="space-y-4">
      <div className="space-y-1.5">
        <Label>Nombre</Label>
        <Input value={nombre} onChange={(e) => setNombre(e.target.value)} />
      </div>
      <div className="space-y-1.5">
        <Label>Rol</Label>
        <Select value={rol} onValueChange={setRol}>
          <SelectTrigger><SelectValue /></SelectTrigger>
          <SelectContent>
            <SelectItem value="usuario">Usuario</SelectItem>
            <SelectItem value="emprendedor">Emprendedor</SelectItem>
            <SelectItem value="admin">Admin</SelectItem>
          </SelectContent>
        </Select>
      </div>
      <div className="space-y-1.5">
        <Label>Estado</Label>
        <Select value={estado} onValueChange={setEstado}>
          <SelectTrigger><SelectValue /></SelectTrigger>
          <SelectContent>
            <SelectItem value="activo">Activo</SelectItem>
            <SelectItem value="suspendido">Suspendido</SelectItem>
            <SelectItem value="inactivo">Inactivo</SelectItem>
          </SelectContent>
        </Select>
      </div>
      <DialogFooter>
        <button
          disabled={pending}
          onClick={() =>
            start(async () => {
              const res = await adminActualizarUsuario({
                id: usuario.id,
                nombre,
                rol: rol as "usuario" | "emprendedor" | "admin",
                estado: estado as "activo" | "suspendido" | "inactivo",
              });
              if (res.ok) {
                toast.success("Usuario actualizado");
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
