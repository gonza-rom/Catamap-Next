import Link from "next/link";
import { Logo } from "./logo";

export function Footer() {
  return (
    <footer className="mt-auto border-t bg-[#1c1207] text-white/80">
      <div className="mx-auto grid max-w-6xl gap-8 px-4 py-12 sm:grid-cols-2 md:grid-cols-4">
        <div className="space-y-3">
          <Logo light />
          <p className="text-sm text-white/60">
            Turismo sostenible y colaborativo para descentralizar y visibilizar Catamarca.
          </p>
        </div>
        <div>
          <h3 className="mb-3 font-semibold text-white">Explorá</h3>
          <ul className="space-y-2 text-sm">
            <li><Link href="/mapa" className="hover:text-brand">Mapa interactivo</Link></li>
            <li><Link href="/lugares" className="hover:text-brand">Todos los lugares</Link></li>
            <li><Link href="/sugerir" className="hover:text-brand">Sugerir un lugar</Link></li>
          </ul>
        </div>
        <div>
          <h3 className="mb-3 font-semibold text-white">Cuenta</h3>
          <ul className="space-y-2 text-sm">
            <li><Link href="/perfil" className="hover:text-brand">Mi perfil</Link></li>
            <li><Link href="/mensajes" className="hover:text-brand">Mensajes</Link></li>
          </ul>
        </div>
        <div>
          <h3 className="mb-3 font-semibold text-white">Proyecto</h3>
          <p className="text-sm text-white/60">
            Seminario Final — Técnico Superior en Desarrollo de Software.
          </p>
        </div>
      </div>
      <div className="border-t border-white/10 py-4 text-center text-xs text-white/50">
        © {new Date().getFullYear()} Catamap
      </div>
    </footer>
  );
}
