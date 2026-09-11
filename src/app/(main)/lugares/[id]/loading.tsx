import { Skeleton } from "@/components/ui/skeleton";

export default function Loading() {
  return (
    <div>
      <Skeleton className="h-[42vh] min-h-72 w-full rounded-none" />
      <div className="mx-auto grid max-w-5xl gap-8 px-4 py-10 lg:grid-cols-[1fr_300px]">
        <div className="space-y-8">
          <div className="space-y-3 rounded-2xl border bg-card p-6">
            <Skeleton className="h-5 w-40" />
            <Skeleton className="h-4 w-full" />
            <Skeleton className="h-4 w-full" />
            <Skeleton className="h-4 w-2/3" />
          </div>
          <div className="space-y-3 rounded-2xl border bg-card p-6">
            <Skeleton className="h-5 w-32" />
            <Skeleton className="h-64 w-full rounded-xl" />
          </div>
          <div className="space-y-3">
            <Skeleton className="h-6 w-40" />
            <Skeleton className="h-24 w-full rounded-xl" />
          </div>
        </div>
        <div className="space-y-3 rounded-2xl border bg-card p-5">
          <Skeleton className="h-5 w-24" />
          <Skeleton className="h-9 w-full rounded-full" />
          <Skeleton className="h-9 w-full rounded-full" />
        </div>
      </div>
    </div>
  );
}
