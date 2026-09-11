import Image from "next/image";
import Link from "next/link";
import { MapPin } from "lucide-react";
import { lugarImg } from "@/lib/images";
import { FavoritoButton } from "./favorito-button";

export type LugarCardData = {
  id: number;
  nombre: string;
  descripcion: string | null;
  imagen: string | null;
  categoria: string | null;
  icono: string | null;
  departamento: string | null;
};

export function LugarCard({
  lugar,
  isFavorito,
  isAuthenticated,
}: {
  lugar: LugarCardData;
  isFavorito: boolean;
  isAuthenticated: boolean;
}) {
  return (
    <article className="group overflow-hidden rounded-2xl border bg-card shadow-sm transition hover:shadow-md">
      <div className="relative aspect-[4/3] overflow-hidden">
        <Image
          src={lugarImg(lugar.imagen)}
          alt={lugar.nombre}
          fill
          sizes="(max-width:768px) 100vw, 33vw"
          className="object-cover transition duration-300 group-hover:scale-105"
        />
        {lugar.categoria && (
          <span className="absolute left-3 top-3 rounded-full bg-black/65 px-2.5 py-1 text-xs font-medium text-white">
            {lugar.icono} {lugar.categoria}
          </span>
        )}
        <FavoritoButton
          idLugar={lugar.id}
          initial={isFavorito}
          isAuthenticated={isAuthenticated}
          className="absolute right-3 top-3"
        />
      </div>
      <div className="space-y-2 p-4">
        {lugar.departamento && (
          <p className="flex items-center gap-1 text-xs font-medium uppercase tracking-wide text-muted-foreground">
            <MapPin className="size-3" /> {lugar.departamento}
          </p>
        )}
        <h3 className="font-heading text-lg font-semibold leading-tight">{lugar.nombre}</h3>
        {lugar.descripcion && (
          <p className="line-clamp-2 text-sm text-muted-foreground">{lugar.descripcion}</p>
        )}
        <div className="flex gap-2 pt-1">
          <Link
            href={`/lugares/${lugar.id}`}
            className="rounded-full bg-brand px-3.5 py-1.5 text-sm font-medium text-white hover:bg-brand-dark"
          >
            Ver detalles
          </Link>
          <Link
            href={`/mapa?lugar=${lugar.id}`}
            className="rounded-full border px-3.5 py-1.5 text-sm font-medium hover:bg-accent"
          >
            Ver en mapa
          </Link>
        </div>
      </div>
    </article>
  );
}
