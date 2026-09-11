"use client";

import { useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Menu, Home, Map, Rows3, User, MessageCircle, PlusCircle, Shield, LogOut, LogIn } from "lucide-react";
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetTrigger } from "@/components/ui/sheet";
import { Logo } from "./logo";
import type { SessionInfo } from "./user-menu";
import { useAuthModal } from "@/components/auth/auth-modal";
import { logoutAction } from "@/lib/actions/auth";

const LINKS = [
  { href: "/", label: "Inicio", icon: Home },
  { href: "/mapa", label: "Mapa", icon: Map },
  { href: "/lugares", label: "Lugares", icon: Rows3 },
];

export function MobileMenu({ session }: { session: SessionInfo }) {
  const [open, setOpen] = useState(false);
  const { open: openAuth } = useAuthModal();
  const router = useRouter();

  return (
    <Sheet open={open} onOpenChange={setOpen}>
      <SheetTrigger asChild>
        <button className="grid size-10 place-items-center rounded-lg hover:bg-accent md:hidden" aria-label="Abrir menú">
          <Menu className="size-5" />
        </button>
      </SheetTrigger>
      <SheetContent side="left" className="flex w-72 flex-col gap-0 p-0">
        <SheetHeader className="border-b p-4">
          <SheetTitle asChild>
            <div onClick={() => setOpen(false)}>
              <Logo />
            </div>
          </SheetTitle>
        </SheetHeader>

        <nav className="flex flex-col gap-1 p-3">
          {LINKS.map(({ href, label, icon: Icon }) => (
            <Link
              key={href}
              href={href}
              onClick={() => setOpen(false)}
              className="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium hover:bg-accent"
            >
              <Icon className="size-4" /> {label}
            </Link>
          ))}
        </nav>

        <div className="mt-auto border-t p-3">
          {session ? (
            <nav className="flex flex-col gap-1">
              <Link
                href="/perfil"
                onClick={() => setOpen(false)}
                className="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium hover:bg-accent"
              >
                <User className="size-4" /> Mi perfil
              </Link>
              <Link
                href="/mensajes"
                onClick={() => setOpen(false)}
                className="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium hover:bg-accent"
              >
                <MessageCircle className="size-4" /> Mensajes
              </Link>
              <Link
                href="/sugerir"
                onClick={() => setOpen(false)}
                className="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium hover:bg-accent"
              >
                <PlusCircle className="size-4" /> Sugerir un lugar
              </Link>
              {session.rol === "admin" && (
                <Link
                  href="/admin"
                  onClick={() => setOpen(false)}
                  className="flex items-center gap-3 rounded-lg px-3 py-2.5 text-sm font-medium hover:bg-accent"
                >
                  <Shield className="size-4" /> Administración
                </Link>
              )}
              <button
                onClick={async () => {
                  setOpen(false);
                  await logoutAction();
                  router.refresh();
                }}
                className="flex items-center gap-3 rounded-lg px-3 py-2.5 text-left text-sm font-medium text-red-600 hover:bg-accent"
              >
                <LogOut className="size-4" /> Cerrar sesión
              </button>
            </nav>
          ) : (
            <button
              onClick={() => {
                setOpen(false);
                openAuth("login");
              }}
              className="flex w-full items-center justify-center gap-2 rounded-full bg-brand px-4 py-2.5 text-sm font-semibold text-white hover:bg-brand-dark"
            >
              <LogIn className="size-4" /> Iniciar sesión
            </button>
          )}
        </div>
      </SheetContent>
    </Sheet>
  );
}
