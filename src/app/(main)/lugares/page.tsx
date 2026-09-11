import type { Metadata } from "next";
import Link from "next/link";
import { getSessionUser } from "@/lib/auth";
import { getLugaresPage, getFiltros, getFavoritoIds } from "@/lib/data/lugares";
import { LugarCard } from "@/components/lugares/lugar-card";
import { LugaresFiltros } from "@/components/lugares/lugares-filtros";
import { LugaresPagination } from "@/components/lugares/lugares-pagination";

export const metadata: Metadata = { title: "Lugares turísticos" };

type SP = Promise<{ categoria?: string; departamento?: string; nombre?: string; page?: string }>;

export default async function LugaresPage({ searchParams }: { searchParams: SP }) {
  const sp = await searchParams;
  const session = await getSessionUser();

  const filter = {
    categoria: sp.categoria ? Number(sp.categoria) : undefined,
    departamento: sp.departamento || undefined,
    nombre: sp.nombre || undefined,
    page: sp.page ? Number(sp.page) : 1,
  };

  const [{ lugares, total, page, totalPages }, filtros, favSet] = await Promise.all([
    getLugaresPage(filter),
    getFiltros(),
    getFavoritoIds(session?.id),
  ]);

  const from = total === 0 ? 0 : (page - 1) * 12 + 1;
  const to = Math.min(page * 12, total);

  return (
    <div className="mx-auto max-w-6xl px-4 py-10">
      <header className="mb-6">
        <h1 className="font-heading text-3xl font-bold">Lugares turísticos de Catamarca</h1>
        <p className="mt-1 text-sm text-muted-foreground">
          {total.toLocaleString("es-AR")} lugares · mostrando {from}–{to}
        </p>
      </header>

      <LugaresFiltros
        categorias={filtros.categorias.map((c) => ({ id: c.idCategoria, nombre: c.nombre }))}
        departamentos={filtros.departamentos.map((d) => d.nombre)}
        current={{ categoria: sp.categoria, departamento: sp.departamento, nombre: sp.nombre }}
      />

      {lugares.length === 0 ? (
        <div className="rounded-2xl border border-dashed p-12 text-center text-muted-foreground">
          No se encontraron lugares con esos filtros.{" "}
          <Link href="/lugares" className="text-brand underline">
            Limpiar
          </Link>
        </div>
      ) : (
        <div className="mt-6 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {lugares.map((l) => (
            <LugarCard
              key={l.id}
              isAuthenticated={!!session}
              isFavorito={favSet.has(l.id)}
              lugar={{
                id: l.id,
                nombre: l.nombre,
                descripcion: l.descripcion,
                imagen: l.imagen,
                categoria: l.categoria?.nombre ?? null,
                icono: l.categoria?.icono ?? null,
                departamento: l.departamento?.nombre ?? null,
              }}
            />
          ))}
        </div>
      )}

      <LugaresPagination page={page} totalPages={totalPages} />
    </div>
  );
}
