"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { cn } from "@/lib/utils";
import { LayoutDashboard, Users, MapPin, Inbox, MessageSquare, Tag, Map } from "lucide-react";

const ITEMS = [
  { href: "/admin", label: "Dashboard", icon: LayoutDashboard },
  { href: "/admin/usuarios", label: "Usuarios", icon: Users },
  { href: "/admin/lugares", label: "Lugares turísticos", icon: MapPin },
  { href: "/admin/sugerencias", label: "Lugares sugeridos", icon: Inbox },
  { href: "/admin/comentarios", label: "Comentarios", icon: MessageSquare },
  { href: "/admin/categorias", label: "Categorías", icon: Tag },
  { href: "/admin/departamentos", label: "Departamentos", icon: Map },
];

export function AdminNav() {
  const pathname = usePathname();
  return (
    <nav className="flex flex-col gap-1 px-3">
      {ITEMS.map(({ href, label, icon: Icon }) => {
        const active = href === "/admin" ? pathname === "/admin" : pathname.startsWith(href);
        return (
          <Link
            key={href}
            href={href}
            className={cn(
              "flex items-center gap-2 rounded-md px-3 py-2 text-sm transition",
              active ? "bg-admin text-white" : "text-white/75 hover:bg-white/10",
            )}
          >
            <Icon className="size-4" /> {label}
          </Link>
        );
      })}
    </nav>
  );
}
