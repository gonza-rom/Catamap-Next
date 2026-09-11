import { Skeleton } from "@/components/ui/skeleton";

export default function Loading() {
  return (
    <div className="mx-auto max-w-4xl px-4 py-10">
      <div className="flex flex-col items-center gap-4 rounded-2xl bg-muted p-8">
        <Skeleton className="size-24 rounded-full" />
        <Skeleton className="h-6 w-40" />
        <Skeleton className="h-9 w-28 rounded-full" />
      </div>
      <div className="mt-6 grid grid-cols-3 gap-3 sm:grid-cols-6">
        {Array.from({ length: 6 }).map((_, i) => (
          <Skeleton key={i} className="h-16 w-full rounded-xl" />
        ))}
      </div>
      <div className="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {Array.from({ length: 6 }).map((_, i) => (
          <Skeleton key={i} className="aspect-video w-full rounded-xl" />
        ))}
      </div>
    </div>
  );
}
