import Link from "next/link";
import Image from "next/image";
import { requireAdmin } from "@/lib/auth";
import { AdminNav } from "@/components/admin/admin-nav";
import { AdminLogoutButton } from "@/components/admin/admin-logout-button";
import { avatarImg } from "@/lib/images";

export const metadata = { title: "Panel de administración" };

export default async function AdminLayout({ children }: { children: React.ReactNode }) {
  const session = await requireAdmin();

  return (
    <div className="flex min-h-screen bg-muted/30">
      <aside className="flex w-64 shrink-0 flex-col bg-gradient-to-b from-[#1e293b] to-[#0f172a] text-white">
        <div className="p-5">
          <Link href="/admin" className="font-heading text-lg font-bold text-admin">
            ⚙ Admin Panel
          </Link>
        </div>
        <AdminNav />
        <div className="mt-auto space-y-1 border-t border-white/10 p-3 text-sm">
          <Link href="/" className="block rounded-md px-3 py-2 hover:bg-white/10">
            ← Volver al sitio
          </Link>
          <AdminLogoutButton />
        </div>
      </aside>

      <div className="flex-1">
        <header className="flex items-center justify-between border-b bg-card px-6 py-3">
          <h1 className="font-heading text-lg font-semibold">Panel de Administración</h1>
          <div className="flex items-center gap-2">
            <span className="text-sm">{session.perfil.nombre}</span>
            <Image
              src={avatarImg(session.perfil.imagenPerfil, session.perfil.nombre)}
              alt=""
              width={32}
              height={32}
              className="size-8 rounded-full object-cover"
            />
          </div>
        </header>
        <main className="p-6">{children}</main>
      </div>
    </div>
  );
}

