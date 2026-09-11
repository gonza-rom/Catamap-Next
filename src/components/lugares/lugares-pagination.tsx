"use client";

import { useRouter, useSearchParams } from "next/navigation";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { cn } from "@/lib/utils";

export function LugaresPagination({ page, totalPages }: { page: number; totalPages: number }) {
  const router = useRouter();
  const params = useSearchParams();

  if (totalPages <= 1) return null;

  function go(p: number) {
    const next = new URLSearchParams(params.toString());
    if (p <= 1) next.delete("page");
    else next.set("page", String(p));
    router.push(`/lugares?${next.toString()}`);
  }

  const pages = pageWindow(page, totalPages);

  return (
    <nav className="mt-10 flex items-center justify-center gap-1">
      <button
        onClick={() => go(page - 1)}
        disabled={page <= 1}
        className="grid size-9 place-items-center rounded-md border disabled:opacity-40"
      >
        <ChevronLeft className="size-4" />
      </button>
      {pages.map((p, i) =>
        p === "…" ? (
          <span key={i} className="px-2 text-muted-foreground">
            …
          </span>
        ) : (
          <button
            key={i}
            onClick={() => go(p)}
            className={cn(
              "grid size-9 place-items-center rounded-md border text-sm",
              p === page ? "bg-app-gradient text-white" : "hover:bg-accent",
            )}
          >
            {p}
          </button>
        ),
      )}
      <button
        onClick={() => go(page + 1)}
        disabled={page >= totalPages}
        className="grid size-9 place-items-center rounded-md border disabled:opacity-40"
      >
        <ChevronRight className="size-4" />
      </button>
    </nav>
  );
}

function pageWindow(current: number, total: number): (number | "…")[] {
  if (total <= 7) return Array.from({ length: total }, (_, i) => i + 1);
  const out: (number | "…")[] = [1];
  const start = Math.max(2, current - 1);
  const end = Math.min(total - 1, current + 1);
  if (start > 2) out.push("…");
  for (let i = start; i <= end; i++) out.push(i);
  if (end < total - 1) out.push("…");
  out.push(total);
  return out;
}
