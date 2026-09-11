"use client";

import { useState, useTransition } from "react";
import Image from "next/image";
import { useRouter, usePathname, useSearchParams } from "next/navigation";
import { toast } from "sonner";
import { Pencil, Trash2 } from "lucide-react";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { CloudinaryUpload } from "@/components/cloudinary-upload";
import { lugarImg } from "@/lib/images";
import { adminActualizarLugar, adminEliminarLugar } from "@/lib/actions/admin";
import { AdminPagination } from "./admin-pagination";

type Lugar = {
  id: number;
  nombre: string;
  imagen: string | null;
  estado: string;
  categoria: string;
  departamento: string;
  idCategoria: number | null;
  idDepartamento: number | null;
  favoritos: number;
  comentarios: number;
};
type Opt = { id: number; nombre: string };
const ALL = "__all__";
const badge: Record<string, string> = {
  aprobado: "bg-green-100 text-green-700",
  pendiente: "bg-amber-100 text-amber-700",
  rechazado: "bg-red-100 text-red-700",
};

export function LugaresAdminTable({
  lugares,
  categorias,
  departamentos,
  page,
  totalPages,
  filtros,
}: {
  lugares: Lugar[];
  categorias: Opt[];
  departamentos: Opt[];
  page: number;
  totalPages: number;
  filtros: { q?: string; estado?: string };
}) {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const [editing, setEditing] = useState<Lugar | null>(null);
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
        <Select value={filtros.estado ?? ALL} onValueChange={(v) => updateParam("estado", v === ALL ? null : v)}>
          <SelectTrigger className="w-44"><SelectValue placeholder="Estado" /></SelectTrigger>
          <SelectContent>
            <SelectItem value={ALL}>Todos los estados</SelectItem>
            <SelectItem value="aprobado">Aprobado</SelectItem>
            <SelectItem value="pendiente">Pendiente</SelectItem>
            <SelectItem value="rechazado">Rechazado</SelectItem>
          </SelectContent>
        </Select>
      </div>

      <div className="overflow-x-auto rounded-xl border bg-card">
        <table className="w-full text-sm">
          <thead className="bg-muted/50 text-left text-xs uppercase text-muted-foreground">
            <tr>
              <th className="p-3">Imagen</th>
              <th className="p-3">Nombre</th>
              <th className="p-3">Categoría</th>
              <th className="p-3">Departamento</th>
              <th className="p-3">Estado</th>
              <th className="p-3">♥ / 💬</th>
              <th className="p-3 text-right">Acciones</th>
            </tr>
          </thead>
          <tbody>
            {lugares.map((l) => (
              <tr key={l.id} className="border-t">
                <td className="p-3">
                  <Image src={lugarImg(l.imagen)} alt="" width={64} height={40} className="h-10 w-16 rounded object-cover" />
                </td>
                <td className="p-3 font-medium">{l.nombre}</td>
                <td className="p-3">{l.categoria}</td>
                <td className="p-3">{l.departamento}</td>
                <td className="p-3">
                  <span className={`rounded-full px-2 py-0.5 text-xs capitalize ${badge[l.estado]}`}>{l.estado}</span>
                </td>
                <td className="p-3 text-xs text-muted-foreground">
                  {l.favoritos} / {l.comentarios}
                </td>
                <td className="p-3 text-right">
                  <button onClick={() => setEditing(l)} className="mr-2 text-muted-foreground hover:text-foreground">
                    <Pencil className="size-4" />
                  </button>
                  <button
                    disabled={pending}
                    onClick={() =>
                      start(async () => {
                        if (!confirm(`¿Eliminar "${l.nombre}"? Se borrarán sus favoritos y comentarios.`)) return;
                        const res = await adminEliminarLugar(l.id);
                        if (res.ok) {
                          toast.success("Lugar eliminado");
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

      <AdminPagination page={page} totalPages={totalPages} />

      <Dialog open={!!editing} onOpenChange={(o) => !o && setEditing(null)}>
        <DialogContent>
          <DialogHeader><DialogTitle>Editar lugar</DialogTitle></DialogHeader>
          {editing && (
            <EditLugarForm
              lugar={editing}
              categorias={categorias}
              departamentos={departamentos}
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

function EditLugarForm({
  lugar,
  categorias,
  departamentos,
  onDone,
}: {
  lugar: Lugar;
  categorias: Opt[];
  departamentos: Opt[];
  onDone: () => void;
}) {
  const [nombre, setNombre] = useState(lugar.nombre);
  const [estado, setEstado] = useState(lugar.estado);
  const [idCategoria, setIdCategoria] = useState(String(lugar.idCategoria ?? ""));
  const [idDepartamento, setIdDepartamento] = useState(String(lugar.idDepartamento ?? ""));
  const [imagen, setImagen] = useState<string | undefined>(undefined);
  const [pending, start] = useTransition();

  return (
    <div className="space-y-4">
      <div className="flex items-center gap-3">
        <Image src={imagen || lugarImg(lugar.imagen)} alt="" width={80} height={56} className="h-14 w-20 rounded object-cover" />
        <CloudinaryUpload label="Cambiar imagen" onUploaded={(url) => setImagen(url)} />
      </div>
      <div className="space-y-1.5">
        <Label>Nombre</Label>
        <Input value={nombre} onChange={(e) => setNombre(e.target.value)} />
      </div>
      <div className="grid grid-cols-2 gap-3">
        <div className="space-y-1.5">
          <Label>Categoría</Label>
          <Select value={idCategoria} onValueChange={setIdCategoria}>
            <SelectTrigger><SelectValue /></SelectTrigger>
            <SelectContent>
              {categorias.map((c) => (
                <SelectItem key={c.id} value={String(c.id)}>{c.nombre}</SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
        <div className="space-y-1.5">
          <Label>Departamento</Label>
          <Select value={idDepartamento} onValueChange={setIdDepartamento}>
            <SelectTrigger><SelectValue /></SelectTrigger>
            <SelectContent>
              {departamentos.map((d) => (
                <SelectItem key={d.id} value={String(d.id)}>{d.nombre}</SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      </div>
      <div className="space-y-1.5">
        <Label>Estado</Label>
        <Select value={estado} onValueChange={setEstado}>
          <SelectTrigger><SelectValue /></SelectTrigger>
          <SelectContent>
            <SelectItem value="aprobado">Aprobado</SelectItem>
            <SelectItem value="pendiente">Pendiente</SelectItem>
            <SelectItem value="rechazado">Rechazado</SelectItem>
          </SelectContent>
        </Select>
      </div>
      <DialogFooter>
        <button
          disabled={pending}
          onClick={() =>
            start(async () => {
              const res = await adminActualizarLugar({
                id: lugar.id,
                nombre,
                estado: estado as "aprobado" | "pendiente" | "rechazado",
                idCategoria: idCategoria ? Number(idCategoria) : null,
                idDepartamento: idDepartamento ? Number(idDepartamento) : null,
                ...(imagen ? { imagen } : {}),
              });
              if (res.ok) {
                toast.success("Lugar actualizado");
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
