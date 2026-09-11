import { Skeleton } from "@/components/ui/skeleton";

export default function Loading() {
  return (
    <div className="mx-auto max-w-6xl px-4 py-10">
      <Skeleton className="h-8 w-72" />
      <Skeleton className="mt-2 h-4 w-48" />

      <div className="mt-6 flex flex-wrap items-center gap-3 rounded-xl border bg-card p-3">
        <Skeleton className="h-9 min-w-52 flex-1" />
        <Skeleton className="h-9 w-44" />
        <Skeleton className="h-9 w-48" />
        <Skeleton className="h-9 w-20" />
      </div>

      <div className="mt-6 grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
        {Array.from({ length: 12 }).map((_, i) => (
          <div key={i} className="overflow-hidden rounded-2xl border bg-card">
            <Skeleton className="aspect-[4/3] w-full rounded-none" />
            <div className="space-y-2 p-4">
              <Skeleton className="h-3 w-24" />
              <Skeleton className="h-4 w-3/4" />
              <Skeleton className="h-3 w-full" />
              <div className="flex gap-2 pt-1">
                <Skeleton className="h-8 w-24 rounded-full" />
                <Skeleton className="h-8 w-24 rounded-full" />
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
