import Link from "next/link";
import { getSessionUser } from "@/lib/auth";
import { Logo } from "./logo";
import { UserMenu, type SessionInfo } from "./user-menu";
import { NavLinks } from "./nav-links";
import { MobileMenu } from "./mobile-menu";
import { InstallAppButton } from "./install-app-button";

export async function Navbar() {
  const session = await getSessionUser();
  const info: SessionInfo = session
    ? {
        id: session.id,
        nombre: session.perfil.nombre,
        email: session.email,
        rol: session.perfil.rol,
        imagenPerfil: session.perfil.imagenPerfil,
      }
    : null;

  return (
    <header className="sticky top-0 z-40 border-b bg-background/90 backdrop-blur">
      <div className="mx-auto flex h-16 max-w-6xl items-center justify-between gap-2 px-3 sm:gap-4 sm:px-4">
        <div className="flex items-center gap-1">
          <MobileMenu session={info} />
          <Logo />
        </div>
        <NavLinks />
        <div className="flex items-center gap-2">
          <InstallAppButton
            className="inline-flex size-10 items-center justify-center gap-1.5 rounded-full border text-sm font-semibold hover:bg-accent sm:w-auto sm:px-4 sm:py-2"
            labelClassName="hidden sm:inline"
          />
          <Link
            href="/mapa"
            className="hidden rounded-full bg-brand px-4 py-2 text-sm font-semibold text-white hover:bg-brand-dark sm:inline-block"
          >
            Ver mapa
          </Link>
          <UserMenu session={info} />
        </div>
      </div>
    </header>
  );
}
