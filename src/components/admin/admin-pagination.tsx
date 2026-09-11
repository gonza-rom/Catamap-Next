"use client";

import { useRouter, useSearchParams, usePathname } from "next/navigation";

export function AdminPagination({ page, totalPages }: { page: number; totalPages: number }) {
  const router = useRouter();
  const pathname = usePathname();
  const params = useSearchParams();

  if (totalPages <= 1) return null;

  function go(p: number) {
    const next = new URLSearchParams(params.toString());
    next.set("page", String(p));
    router.push(`${pathname}?${next.toString()}`);
  }

  return (
    <div className="mt-4 flex items-center justify-center gap-2 text-sm">
      <button onClick={() => go(page - 1)} disabled={page <= 1} className="rounded-md border px-3 py-1 disabled:opacity-40">
        Anterior
      </button>
      <span>
        Página {page} de {totalPages}
      </span>
      <button
        onClick={() => go(page + 1)}
        disabled={page >= totalPages}
        className="rounded-md border px-3 py-1 disabled:opacity-40"
      >
        Siguiente
      </button>
    </div>
  );
}
