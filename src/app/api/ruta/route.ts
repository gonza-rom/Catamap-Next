import { NextResponse } from "next/server";

/**
 * Proxy a OpenRouteService Directions. Recibe { from:[lng,lat], to:[lng,lat] }
 * y devuelve un LineString GeoJSON con la ruta.
 */
export async function POST(req: Request) {
  const key = process.env.ORS_API_KEY;
  if (!key) {
    return NextResponse.json(
      { error: "Ruteo no configurado (falta ORS_API_KEY)" },
      { status: 503 },
    );
  }

  let body: { from?: [number, number]; to?: [number, number] };
  try {
    body = await req.json();
  } catch {
    return NextResponse.json({ error: "JSON inválido" }, { status: 400 });
  }
  const { from, to } = body;
  if (!from || !to) {
    return NextResponse.json({ error: "Faltan coordenadas" }, { status: 400 });
  }

  const r = await fetch("https://api.openrouteservice.org/v2/directions/driving-car/geojson", {
    method: "POST",
    headers: { "Content-Type": "application/json", Authorization: key },
    body: JSON.stringify({ coordinates: [from, to] }),
  });

  if (!r.ok) {
    return NextResponse.json({ error: "No se pudo calcular la ruta" }, { status: 502 });
  }

  const data = await r.json();
  const feature = data.features?.[0];
  const distancia = feature?.properties?.summary?.distance ?? null;
  const duracion = feature?.properties?.summary?.duration ?? null;

  return NextResponse.json({ geometry: feature?.geometry ?? null, distancia, duracion });
}
