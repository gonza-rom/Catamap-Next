import { Skeleton } from "@/components/ui/skeleton";

export default function Loading() {
  return (
    <div className="mx-auto flex h-[calc(100dvh-4rem)] max-w-6xl">
      <aside className="flex w-full max-w-xs flex-col border-r">
        <div className="bg-muted p-4">
          <Skeleton className="h-6 w-28 bg-background/50" />
        </div>
        <div className="space-y-1 p-2">
          {Array.from({ length: 6 }).map((_, i) => (
            <div key={i} className="flex items-center gap-3 p-2">
              <Skeleton className="size-10 shrink-0 rounded-full" />
              <div className="flex-1 space-y-1.5">
                <Skeleton className="h-3.5 w-24" />
                <Skeleton className="h-3 w-32" />
              </div>
            </div>
          ))}
        </div>
      </aside>
      <section className="hidden flex-1 items-center justify-center md:flex">
        <Skeleton className="h-4 w-48" />
      </section>
    </div>
  );
}
