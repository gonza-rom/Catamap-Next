"use client";

import { useTransition } from "react";
import Image from "next/image";
import { useRouter, usePathname, useSearchParams } from "next/navigation";
import { toast } from "sonner";
import { Check, X } from "lucide-react";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { lugarImg } from "@/lib/images";
import { fecha } from "@/lib/format";
import { adminAprobarSugerencia, adminRechazarSugerencia } from "@/lib/actions/admin";

type Sug = {
  id: number;
  nombre: string;
  imagen: string | null;
  usuarioNombre: string;
  categoria: string;
  departamento: string;
  fecha: string;
};

export function SugerenciasAdminTable({ estado, sugerencias }: { estado: string; sugerencias: Sug[] }) {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();
  const [pending, start] = useTransition();

  function setEstado(v: string) {
    const next = new URLSearchParams(params.toString());
    next.set("estado", v);
    router.push(`${pathname}?${next.toString()}`);
  }

  return (
    <div className="space-y-4">
      <Select value={estado} onValueChange={setEstado}>
        <SelectTrigger className="w-44"><SelectValue /></SelectTrigger>
        <SelectContent>
          <SelectItem value="pendiente">Pendientes</SelectItem>
          <SelectItem value="aprobado">Aprobados</SelectItem>
          <SelectItem value="rechazado">Rechazados</SelectItem>
        </SelectContent>
      </Select>

      {sugerencias.length === 0 ? (
        <p className="rounded-xl border border-dashed p-8 text-center text-sm text-muted-foreground">
          No hay sugerencias en este estado.
        </p>
      ) : (
        <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
          {sugerencias.map((s) => (
            <div key={s.id} className="overflow-hidden rounded-xl border bg-card">
              <div className="relative aspect-video bg-muted">
                <Image
                  src={lugarImg(s.imagen)}
                  alt={s.nombre}
                  fill
                  sizes="(max-width: 640px) 100vw, (max-width: 1024px) 50vw, 33vw"
                  className="object-cover"
                />
              </div>
              <div className="space-y-1 p-3">
                <p className="font-medium">{s.nombre}</p>
                <p className="text-xs text-muted-foreground">
                  {s.categoria} · {s.departamento}
                </p>
                <p className="text-xs text-muted-foreground">
                  Por {s.usuarioNombre} · {fecha(s.fecha)}
                </p>
                {estado === "pendiente" && (
                  <div className="flex gap-2 pt-2">
                    <button
                      disabled={pending}
                      onClick={() =>
                        start(async () => {
                          const res = await adminAprobarSugerencia(s.id);
                          if (res.ok) {
                            toast.success("Lugar aprobado y publicado");
                            router.refresh();
                          } else toast.error(res.error);
                        })
                      }
                      className="flex flex-1 items-center justify-center gap-1 rounded-full bg-green-600 py-1.5 text-xs font-medium text-white hover:bg-green-700"
                    >
                      <Check className="size-3.5" /> Aprobar
                    </button>
                    <button
                      disabled={pending}
                      onClick={() =>
                        start(async () => {
                          const motivo = prompt("Motivo de rechazo (opcional):") ?? undefined;
                          const res = await adminRechazarSugerencia(s.id, motivo);
                          if (res.ok) {
                            toast.success("Sugerencia rechazada");
                            router.refresh();
                          } else toast.error(res.error);
                        })
                      }
                      className="flex flex-1 items-center justify-center gap-1 rounded-full bg-red-500 py-1.5 text-xs font-medium text-white hover:bg-red-600"
                    >
                      <X className="size-3.5" /> Rechazar
                    </button>
                  </div>
                )}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
