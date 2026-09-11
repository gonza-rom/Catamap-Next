import Link from "next/link";
import Image from "next/image";
import { Settings, ArrowLeft } from "lucide-react";
import { requireAdmin } from "@/lib/auth";
import { AdminNav } from "@/components/admin/admin-nav";
import { AdminLogoutButton } from "@/components/admin/admin-logout-button";
import { AdminMobileNav } from "@/components/admin/admin-mobile-nav";
import { avatarImg } from "@/lib/images";

export const metadata = { title: "Panel de administración" };

export default async function AdminLayout({ children }: { children: React.ReactNode }) {
  const session = await requireAdmin();

  return (
    <div className="flex min-h-screen bg-muted/30">
      <aside className="hidden w-64 shrink-0 flex-col bg-gradient-to-b from-[#1e293b] to-[#0f172a] text-white lg:flex">
        <div className="p-5">
          <Link href="/admin" className="flex items-center gap-2 font-heading text-lg font-bold text-admin">
            <Settings className="size-5" /> Admin Panel
          </Link>
        </div>
        <AdminNav />
        <div className="mt-auto space-y-1 border-t border-white/10 p-3 text-sm">
          <Link href="/" className="flex items-center gap-2 rounded-md px-3 py-2 hover:bg-white/10">
            <ArrowLeft className="size-4" /> Volver al sitio
          </Link>
          <AdminLogoutButton />
        </div>
      </aside>

      <div className="min-w-0 flex-1">
        <header className="flex items-center justify-between gap-3 border-b bg-card px-4 py-3 sm:px-6">
          <div className="flex items-center gap-3">
            <AdminMobileNav />
            <h1 className="font-heading text-base font-semibold sm:text-lg">Panel de Administración</h1>
          </div>
          <div className="flex items-center gap-2">
            <span className="hidden text-sm sm:inline">{session.perfil.nombre}</span>
            <Image
              src={avatarImg(session.perfil.imagenPerfil, session.perfil.nombre)}
              alt=""
              width={32}
              height={32}
              className="size-8 shrink-0 rounded-full object-cover"
            />
          </div>
        </header>
        <main className="overflow-x-auto p-4 sm:p-6">{children}</main>
      </div>
    </div>
  );
}
