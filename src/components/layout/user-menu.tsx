"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useQuery } from "@tanstack/react-query";
import { LogOut, MessageCircle, Shield, User } from "lucide-react";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { useAuthModal } from "@/components/auth/auth-modal";
import { logoutAction } from "@/lib/actions/auth";

export type SessionInfo = {
  id: string;
  nombre: string;
  email: string;
  rol: "usuario" | "emprendedor" | "admin";
  imagenPerfil: string | null;
} | null;

export function UserMenu({ session }: { session: SessionInfo }) {
  const { open } = useAuthModal();
  const router = useRouter();

  const { data: unread = 0 } = useQuery({
    queryKey: ["mensajes-unread"],
    queryFn: async () => {
      const r = await fetch("/api/mensajes/unread");
      if (!r.ok) return 0;
      return (await r.json()).total as number;
    },
    enabled: !!session,
    refetchInterval: 15_000,
  });

  if (!session) {
    return (
      <Button onClick={() => open("login")} className="rounded-full">
        Iniciar sesión
      </Button>
    );
  }

  const initials = session.nombre.slice(0, 2).toUpperCase();

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <button className="flex items-center gap-2 rounded-full border bg-card py-1 pl-1 pr-3 hover:bg-accent transition">
          <Avatar className="size-8">
            {session.imagenPerfil && <AvatarImage src={session.imagenPerfil} alt={session.nombre} />}
            <AvatarFallback className="bg-app-gradient text-white text-xs">{initials}</AvatarFallback>
          </Avatar>
          <span className="text-sm font-medium max-w-28 truncate">{session.nombre}</span>
          {unread > 0 && (
            <span className="ml-1 rounded-full bg-red-500 px-1.5 text-[10px] font-bold text-white">
              {unread}
            </span>
          )}
        </button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end" className="w-52">
        <DropdownMenuLabel className="truncate font-normal text-muted-foreground">
          {session.email}
        </DropdownMenuLabel>
        <DropdownMenuSeparator />
        <DropdownMenuItem asChild>
          <Link href="/perfil">
            <User className="size-4" /> Mi perfil
          </Link>
        </DropdownMenuItem>
        <DropdownMenuItem asChild>
          <Link href="/mensajes">
            <MessageCircle className="size-4" /> Mensajes
            {unread > 0 && (
              <span className="ml-auto rounded-full bg-red-500 px-1.5 text-[10px] font-bold text-white">
                {unread}
              </span>
            )}
          </Link>
        </DropdownMenuItem>
        {session.rol === "admin" && (
          <DropdownMenuItem asChild>
            <Link href="/admin">
              <Shield className="size-4" /> Administración
            </Link>
          </DropdownMenuItem>
        )}
        <DropdownMenuSeparator />
        <DropdownMenuItem
          onClick={async () => {
            await logoutAction();
            router.refresh();
          }}
        >
          <LogOut className="size-4" /> Cerrar sesión
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
