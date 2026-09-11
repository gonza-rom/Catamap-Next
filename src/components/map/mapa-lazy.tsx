"use client";

import dynamic from "next/dynamic";
import type { MapaLugar } from "@/lib/data/mapa";

const MapaCatamarca = dynamic(() => import("./mapa-catamarca"), {
  ssr: false,
  loading: () => (
    <div className="grid h-[100dvh] w-full place-items-center bg-muted">
      <p className="text-sm text-muted-foreground">Cargando mapa…</p>
    </div>
  ),
});

export function MapaClient(props: {
  lugares: MapaLugar[];
  favoritos: number[];
  isAuthenticated: boolean;
}) {
  return <MapaCatamarca {...props} />;
}
