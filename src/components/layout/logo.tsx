import Image from "next/image";
import Link from "next/link";
import { cn } from "@/lib/utils";

export function Logo({ className, light = false }: { className?: string; light?: boolean }) {
  return (
    <Link href="/" className={cn("flex items-center gap-2 font-heading font-extrabold text-xl", className)}>
      <Image src="/img/CATAMAP.png" alt="Catamap" width={36} height={36} className="size-9 object-contain" />
      <span className={light ? "text-white" : "text-foreground"}>
        CATA<span className="text-brand">MAP</span>
      </span>
    </Link>
  );
}
