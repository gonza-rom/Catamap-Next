import { Skeleton } from "@/components/ui/skeleton";

export default function Loading() {
  return (
    <div className="mx-auto max-w-5xl px-4 py-8">
      <div className="flex flex-col items-center gap-4 rounded-2xl bg-muted p-5 sm:p-6 md:flex-row">
        <Skeleton className="size-20 shrink-0 rounded-full sm:size-22" />
        <div className="w-full min-w-0 flex-1 space-y-2">
          <Skeleton className="mx-auto h-6 w-40 md:mx-0" />
          <Skeleton className="mx-auto h-4 w-56 md:mx-0" />
        </div>
        <div className="grid w-full max-w-xs grid-cols-4 gap-2 md:w-auto">
          {Array.from({ length: 4 }).map((_, i) => (
            <Skeleton key={i} className="h-10 w-full" />
          ))}
        </div>
      </div>

      <div className="mt-6 flex gap-2 overflow-hidden">
        {Array.from({ length: 7 }).map((_, i) => (
          <Skeleton key={i} className="h-8 w-24 shrink-0 rounded-md" />
        ))}
      </div>

      <div className="mt-4 grid gap-6 md:grid-cols-2">
        <Skeleton className="h-64 w-full rounded-xl" />
        <Skeleton className="h-64 w-full rounded-xl" />
      </div>
    </div>
  );
}
