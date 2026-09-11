import type { Metadata } from "next";
import { requireUser } from "@/lib/auth";
import { getFiltros } from "@/lib/data/lugares";
import { SugerirLugarForm } from "@/components/lugares/sugerir-lugar-form";

export const metadata: Metadata = { title: "Sugerir un lugar" };

export default async function SugerirPage() {
  await requireUser();
  const { categorias, departamentos } = await getFiltros();

  return (
    <div className="mx-auto max-w-3xl px-4 py-10">
      <h1 className="font-heading text-3xl font-bold">Sugerir un lugar</h1>
      <p className="mt-1 text-muted-foreground">
        Completá los datos y marcá la ubicación. Un administrador revisará tu aporte antes de
        publicarlo en el mapa.
      </p>
      <div className="mt-6 rounded-2xl border bg-card p-6">
        <SugerirLugarForm
          categorias={categorias.map((c) => ({ id: c.idCategoria, nombre: c.nombre }))}
          departamentos={departamentos.map((d) => ({ id: d.id, nombre: d.nombre }))}
        />
      </div>
    </div>
  );
}
