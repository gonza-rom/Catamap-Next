"use client";

import { useState, useTransition } from "react";
import dynamic from "next/dynamic";
import { useRouter } from "next/navigation";
import Image from "next/image";
import { toast } from "sonner";
import { Check, Loader2, MapPin } from "lucide-react";
import { CategoryIcon } from "@/components/category-icon";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { CloudinaryUpload } from "@/components/cloudinary-upload";
import { crearSugerencia } from "@/lib/actions/sugerencias";

const LocationPicker = dynamic(() => import("@/components/map/location-picker"), {
  ssr: false,
  loading: () => <div className="h-72 w-full animate-pulse rounded-xl bg-muted" />,
});

type Opt = { id: number; nombre: string };

export function SugerirLugarForm({
  categorias,
  departamentos,
  onDone,
}: {
  categorias: Opt[];
  departamentos: Opt[];
  onDone?: () => void;
}) {
  const router = useRouter();
  const [pending, start] = useTransition();
  const [coords, setCoords] = useState<{ lat: number; lng: number } | null>(null);
  const [imagen, setImagen] = useState("");
  const [idCategoria, setIdCategoria] = useState("");
  const [idDepartamento, setIdDepartamento] = useState("");
  const [desc, setDesc] = useState("");

  function submit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const fd = new FormData(e.currentTarget);
    if (!coords) {
      toast.error("Marcá la ubicación en el mapa");
      return;
    }
    start(async () => {
      const res = await crearSugerencia({
        nombre: String(fd.get("nombre") || ""),
        descripcion: desc,
        direccion: String(fd.get("direccion") || ""),
        lat: coords.lat,
        lng: coords.lng,
        idCategoria: Number(idCategoria),
        idDepartamento: Number(idDepartamento),
        imagen,
      });
      if (!res.ok) {
        toast.error(res.error);
        return;
      }
      toast.success("¡Sugerencia enviada! Un administrador la revisará.");
      (e.target as HTMLFormElement).reset();
      setCoords(null);
      setImagen("");
      setDesc("");
      router.refresh();
      onDone?.();
    });
  }

  return (
    <form onSubmit={submit} className="space-y-4">
      <div className="grid gap-4 sm:grid-cols-2">
        <div className="space-y-1.5">
          <Label htmlFor="nombre">Nombre del lugar *</Label>
          <Input id="nombre" name="nombre" required minLength={3} />
        </div>
        <div className="space-y-1.5">
          <Label htmlFor="direccion">Dirección / referencia</Label>
          <Input id="direccion" name="direccion" />
        </div>
      </div>

      <div className="space-y-1.5">
        <Label htmlFor="descripcion">Descripción * (mínimo 50 caracteres)</Label>
        <Textarea
          id="descripcion"
          value={desc}
          onChange={(e) => setDesc(e.target.value)}
          rows={4}
          required
        />
        <p className="text-xs text-muted-foreground">{desc.length}/50</p>
      </div>

      <div className="grid gap-4 sm:grid-cols-2">
        <div className="space-y-1.5">
          <Label>Categoría *</Label>
          <Select value={idCategoria} onValueChange={setIdCategoria}>
            <SelectTrigger>
              <SelectValue placeholder="Elegí una categoría" />
            </SelectTrigger>
            <SelectContent>
              {categorias.map((c) => (
                <SelectItem key={c.id} value={String(c.id)}>
                  <CategoryIcon nombre={c.nombre} className="mr-1 inline size-4 text-brand" />
                  {c.nombre}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
        <div className="space-y-1.5">
          <Label>Departamento *</Label>
          <Select value={idDepartamento} onValueChange={setIdDepartamento}>
            <SelectTrigger>
              <SelectValue placeholder="Elegí un departamento" />
            </SelectTrigger>
            <SelectContent>
              {departamentos.map((d) => (
                <SelectItem key={d.id} value={String(d.id)}>
                  {d.nombre}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      </div>

      <div className="space-y-1.5">
        <Label className="flex items-center gap-1">
          <MapPin className="size-4" /> Ubicación * — hacé clic en el mapa
        </Label>
        <LocationPicker value={coords} onChange={setCoords} />
        {coords && (
          <p className="flex items-center gap-1 text-xs text-green-600">
            <Check className="size-3" /> {coords.lat.toFixed(5)}, {coords.lng.toFixed(5)}
          </p>
        )}
      </div>

      <div className="space-y-1.5">
        <Label>Foto (opcional)</Label>
        <div className="flex items-center gap-3">
          <CloudinaryUpload onUploaded={(url) => setImagen(url)} label="Subir foto" />
          {imagen && <Image src={imagen} alt="" width={64} height={64} className="size-16 rounded-lg object-cover" />}
        </div>
      </div>

      <button
        type="submit"
        disabled={pending}
        className="inline-flex items-center gap-2 rounded-full bg-brand px-6 py-2.5 font-medium text-white hover:bg-brand-dark disabled:opacity-60"
      >
        {pending && <Loader2 className="size-4 animate-spin" />}
        Enviar sugerencia
      </button>
    </form>
  );
}
