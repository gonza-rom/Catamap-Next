import type { Metadata } from "next";
import { getMapaLugares } from "@/lib/data/mapa";
import { getSessionUser } from "@/lib/auth";
import { getFavoritoIds } from "@/lib/data/lugares";
import { MapaClient } from "@/components/map/mapa-lazy";

export const metadata: Metadata = { title: "Mapa interactivo" };

export default async function MapaPage() {
  const session = await getSessionUser();
  const [lugares, favSet] = await Promise.all([
    getMapaLugares(),
    getFavoritoIds(session?.id),
  ]);

  return (
    <MapaClient
      lugares={lugares}
      favoritos={[...favSet]}
      isAuthenticated={!!session}
    />
  );
}
