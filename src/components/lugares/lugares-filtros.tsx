"use client";

import { useRouter, useSearchParams } from "next/navigation";
import { useTransition } from "react";
import { Search, X } from "lucide-react";
import { Input } from "@/components/ui/input";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

type Props = {
  categorias: { id: number; nombre: string }[];
  departamentos: string[];
  current: { categoria?: string; departamento?: string; nombre?: string };
};

const ALL = "__all__";

export function LugaresFiltros({ categorias, departamentos, current }: Props) {
  const router = useRouter();
  const params = useSearchParams();
  const [pending, start] = useTransition();

  function update(key: string, value: string | null) {
    const next = new URLSearchParams(params.toString());
    if (value) next.set(key, value);
    else next.delete(key);
    next.delete("page");
    start(() => router.push(`/lugares?${next.toString()}`));
  }

  const hasFilters = current.categoria || current.departamento || current.nombre;

  return (
    <form
      className="flex flex-wrap items-center gap-3 rounded-xl border bg-card p-3"
      onSubmit={(e) => {
        e.preventDefault();
        const fd = new FormData(e.currentTarget);
        update("nombre", String(fd.get("nombre") || "") || null);
      }}
      data-pending={pending}
    >
      <div className="relative min-w-52 flex-1">
        <Search className="pointer-events-none absolute left-3 top-1/2 size-4 -translate-y-1/2 text-muted-foreground" />
        <Input
          name="nombre"
          defaultValue={current.nombre ?? ""}
          placeholder="Buscar por nombre…"
          className="pl-9"
        />
      </div>

      <Select
        value={current.categoria ?? ALL}
        onValueChange={(v) => update("categoria", v === ALL ? null : v)}
      >
        <SelectTrigger className="w-44">
          <SelectValue placeholder="Categoría" />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value={ALL}>Todas las categorías</SelectItem>
          {categorias.map((c) => (
            <SelectItem key={c.id} value={String(c.id)}>
              {c.nombre}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>

      <Select
        value={current.departamento ?? ALL}
        onValueChange={(v) => update("departamento", v === ALL ? null : v)}
      >
        <SelectTrigger className="w-48">
          <SelectValue placeholder="Departamento" />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value={ALL}>Todos los departamentos</SelectItem>
          {departamentos.map((d) => (
            <SelectItem key={d} value={d}>
              {d}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>

      <button
        type="submit"
        className="rounded-md bg-brand px-4 py-2 text-sm font-medium text-white hover:bg-brand-dark"
      >
        Buscar
      </button>

      {hasFilters && (
        <button
          type="button"
          onClick={() => start(() => router.push("/lugares"))}
          className="flex items-center gap-1 text-sm text-muted-foreground hover:text-foreground"
        >
          <X className="size-4" /> Limpiar
        </button>
      )}
    </form>
  );
}
