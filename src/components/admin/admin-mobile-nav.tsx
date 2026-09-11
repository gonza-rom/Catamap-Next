"use client";

import { useState } from "react";
import Link from "next/link";
import { Menu, Settings, ArrowLeft } from "lucide-react";
import { Sheet, SheetContent, SheetTrigger, SheetTitle, SheetHeader } from "@/components/ui/sheet";
import { AdminNav } from "./admin-nav";
import { AdminLogoutButton } from "./admin-logout-button";

export function AdminMobileNav() {
  const [open, setOpen] = useState(false);
  return (
    <Sheet open={open} onOpenChange={setOpen}>
      <SheetTrigger asChild>
        <button className="grid size-9 place-items-center rounded-md border lg:hidden" aria-label="Abrir menú">
          <Menu className="size-5" />
        </button>
      </SheetTrigger>
      <SheetContent
        side="left"
        className="flex w-64 flex-col gap-0 bg-gradient-to-b from-[#1e293b] to-[#0f172a] p-0 text-white [&_svg]:text-white"
      >
        <SheetHeader className="p-5">
          <SheetTitle asChild>
            <Link href="/admin" onClick={() => setOpen(false)} className="flex items-center gap-2 font-heading text-lg font-bold text-admin">
              <Settings className="size-5" /> Admin Panel
            </Link>
          </SheetTitle>
        </SheetHeader>
        <div onClick={() => setOpen(false)}>
          <AdminNav />
        </div>
        <div className="mt-auto space-y-1 border-t border-white/10 p-3 text-sm">
          <Link href="/" className="flex items-center gap-2 rounded-md px-3 py-2 hover:bg-white/10">
            <ArrowLeft className="size-4" /> Volver al sitio
          </Link>
          <AdminLogoutButton />
        </div>
      </SheetContent>
    </Sheet>
  );
}
