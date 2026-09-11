"use client";

import "leaflet/dist/leaflet.css";
import "./map-styles.css";
import { useEffect, useMemo, useRef, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import L from "leaflet";
import { toast } from "sonner";
import { Search, SlidersHorizontal, LocateFixed, Star, X, ArrowLeft } from "lucide-react";
import Link from "next/link";
import { emojiIcon, userIcon, favIcon } from "./icons";
import type { MapaLugar } from "@/lib/data/mapa";
import { lugarImg } from "@/lib/images";
import { cn } from "@/lib/utils";

const BASE_LAYERS: Record<string, string> = {
  "🗺️ Rutas": "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
  "🌍 Moderno": "https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png",
  "🏔️ Terreno": "https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}",
  "⚪ Blanco": "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
};

type Props = {
  lugares: MapaLugar[];
  favoritos: number[];
  isAuthenticated: boolean;
};

export default function MapaCatamarca({ lugares, favoritos, isAuthenticated }: Props) {
  const mapRef = useRef<L.Map | null>(null);
  const containerRef = useRef<HTMLDivElement>(null);
  const markersByCat = useRef<Map<string, L.Marker[]>>(new Map());
  const activeCats = useRef<Set<string>>(new Set());
  const userLatLng = useRef<L.LatLng | null>(null);
  const routeLayer = useRef<L.GeoJSON | null>(null);
  const favLayer = useRef<L.LayerGroup | null>(null);

  const router = useRouter();
  const params = useSearchParams();
  const favSet = useMemo(() => new Set(favoritos), [favoritos]);

  const [panel, setPanel] = useState<"cats" | "search" | null>(null);
  const [query, setQuery] = useState("");
  const [showFavs, setShowFavs] = useState(false);

  const categorias = useMemo(() => {
    const m = new Map<string, string>();
    for (const l of lugares) if (!m.has(l.categoria)) m.set(l.categoria, l.icono);
    return [...m.entries()].sort((a, b) => a[0].localeCompare(b[0]));
  }, [lugares]);

  // ── init map ──
  useEffect(() => {
    if (mapRef.current || !containerRef.current) return;
    const map = L.map(containerRef.current, { zoomControl: false, attributionControl: false }).setView(
      [-28.47, -65.79],
      7,
    );
    mapRef.current = map;
    L.control.zoom({ position: "bottomright" }).addTo(map);
    L.tileLayer(BASE_LAYERS["🗺️ Rutas"], { maxZoom: 18 }).addTo(map);
    L.control.attribution({ position: "bottomleft", prefix: false }).addAttribution("© OpenStreetMap").addTo(map);

    // capa de departamentos
    fetch("/data/departamentos-catamarca.json")
      .then((r) => r.json())
      .then((geo) => {
        const layer = L.geoJSON(geo, {
          style: { color: "#111", weight: 1.5, fillColor: "#fff", fillOpacity: 0 },
          onEachFeature: (feature, lyr) => {
            const nombre: string = (feature.properties?.departamento ?? "").toUpperCase();
            lyr.on("mouseover", () => (lyr as L.Path).setStyle({ color: "#e07b39", weight: 3 }));
            lyr.on("mouseout", () => (lyr as L.Path).setStyle({ color: "#111", weight: 1.5 }));
            lyr.on("click", () => {
              const del = lugares.filter((l) => l.departamento === nombre);
              const html = del.length
                ? `<div class="cm-popup"><h4>${nombre}</h4><p>${del.length} lugares</p>` +
                  del
                    .slice(0, 40)
                    .map((l) => `<a href="/lugares/${l.id}" style="display:block;padding:2px 0">${l.icono} ${l.nombre}</a>`)
                    .join("") +
                  (del.length > 40 ? `<p>…y ${del.length - 40} más</p>` : "") +
                  `</div>`
                : `<div class="cm-popup"><h4>${nombre}</h4><p>Sin lugares cargados</p></div>`;
              L.popup({ maxHeight: 260 }).setLatLng((lyr as L.Polygon).getBounds().getCenter()).setContent(html).openOn(map);
            });
          },
        }).addTo(map);
        try {
          map.fitBounds(layer.getBounds(), { padding: [20, 20] });
          map.setMaxBounds(layer.getBounds().pad(0.3));
          map.setMinZoom(map.getBoundsZoom(layer.getBounds()));
        } catch {}
      })
      .catch(() => {});

    // marcadores por categoría (lazy: se crean pero no se agregan)
    for (const l of lugares) {
      const m = L.marker([l.lat, l.lng], { icon: emojiIcon(l.icono) }).bindPopup(popupHtml(l), {
        maxWidth: 260,
        className: "cm-popup-wrapper",
      });
      const arr = markersByCat.current.get(l.categoria) ?? [];
      arr.push(m);
      markersByCat.current.set(l.categoria, arr);
    }

    // delegación de clicks en popups
    map.on("popupopen", (e) => {
      const node = (e.popup as L.Popup).getElement();
      node?.querySelector<HTMLButtonElement>(".cm-btn-route")?.addEventListener("click", (ev) => {
        const t = ev.currentTarget as HTMLElement;
        trazarRuta(Number(t.dataset.lat), Number(t.dataset.lng));
      });
    });

    // geolocalización
    map.locate({ setView: false, maxZoom: 14 });
    map.on("locationfound", (e) => {
      userLatLng.current = e.latlng;
      L.marker(e.latlng, { icon: userIcon() }).addTo(map).bindPopup("Estás acá");
    });

    return () => {
      map.remove();
      mapRef.current = null;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // deep-link ?lugar=
  useEffect(() => {
    const id = params.get("lugar");
    if (!id || !mapRef.current) return;
    const l = lugares.find((x) => x.id === Number(id));
    if (!l) return;
    const map = mapRef.current;
    // asegurar que la categoría esté activa
    if (!activeCats.current.has(l.categoria)) toggleCat(l.categoria, true);
    map.flyTo([l.lat, l.lng], 15, { duration: 1 });
    const tmp = L.marker([l.lat, l.lng], { icon: emojiIcon(l.icono) }).addTo(map).bindPopup(popupHtml(l)).openPopup();
    setTimeout(() => map.removeLayer(tmp), 20000);
    router.replace("/mapa");
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [params, lugares]);

  function toggleCat(cat: string, force?: boolean) {
    const map = mapRef.current;
    if (!map) return;
    const on = force ?? !activeCats.current.has(cat);
    const markers = markersByCat.current.get(cat) ?? [];
    if (on) {
      activeCats.current.add(cat);
      markers.forEach((m) => m.addTo(map));
    } else {
      activeCats.current.delete(cat);
      markers.forEach((m) => map.removeLayer(m));
    }
    setPanel((p) => p); // re-render checkboxes
    forceRerender((n) => n + 1);
  }

  const [, forceRerender] = useState(0);

  function limpiarFiltros() {
    const map = mapRef.current;
    if (!map) return;
    for (const cat of [...activeCats.current]) {
      (markersByCat.current.get(cat) ?? []).forEach((m) => map.removeLayer(m));
    }
    activeCats.current.clear();
    forceRerender((n) => n + 1);
  }

  async function trazarRuta(lat: number, lng: number) {
    const map = mapRef.current;
    if (!map) return;
    if (!userLatLng.current) {
      toast.error("Activá tu ubicación para trazar la ruta");
      return;
    }
    if (routeLayer.current) {
      map.removeLayer(routeLayer.current);
      routeLayer.current = null;
      return;
    }
    const id = toast.loading("Calculando ruta…");
    try {
      const r = await fetch("/api/ruta", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          from: [userLatLng.current.lng, userLatLng.current.lat],
          to: [lng, lat],
        }),
      });
      const data = await r.json();
      if (!r.ok || !data.geometry) throw new Error(data.error || "Error");
      routeLayer.current = L.geoJSON(data.geometry, { style: { color: "#4CAF50", weight: 5 } }).addTo(map);
      map.fitBounds(routeLayer.current.getBounds(), { padding: [40, 40] });
      toast.success(
        `Ruta: ${(data.distancia / 1000).toFixed(1)} km · ${Math.round(data.duracion / 60)} min`,
        { id },
      );
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "No se pudo calcular la ruta", { id });
    }
  }

  function irAMiUbicacion() {
    const map = mapRef.current;
    if (!map) return;
    if (userLatLng.current) map.flyTo(userLatLng.current, 14);
    else map.locate({ setView: true, maxZoom: 14 });
  }

  function toggleFavsEnMapa() {
    const map = mapRef.current;
    if (!map) return;
    if (favLayer.current) {
      map.removeLayer(favLayer.current);
      favLayer.current = null;
      setShowFavs(false);
      return;
    }
    const favs = lugares.filter((l) => favSet.has(l.id));
    if (!favs.length) {
      toast.info("No tenés favoritos todavía");
      return;
    }
    const group = L.layerGroup(
      favs.map((l) => L.marker([l.lat, l.lng], { icon: favIcon() }).bindPopup(popupHtml(l))),
    ).addTo(map);
    favLayer.current = group;
    setShowFavs(true);
    map.flyToBounds(L.latLngBounds(favs.map((l) => [l.lat, l.lng])), { padding: [50, 50] });
  }

  const resultados = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (q.length < 2) return [];
    return lugares
      .filter(
        (l) =>
          l.nombre.toLowerCase().includes(q) ||
          l.categoria.toLowerCase().includes(q) ||
          l.departamento.toLowerCase().includes(q),
      )
      .slice(0, 30);
  }, [query, lugares]);

  function irALugar(l: MapaLugar) {
    const map = mapRef.current;
    if (!map) return;
    if (!activeCats.current.has(l.categoria)) toggleCat(l.categoria, true);
    map.flyTo([l.lat, l.lng], 16, { duration: 1 });
    setPanel(null);
  }

  return (
    <div className="relative h-[100dvh] w-full overflow-hidden">
      <div ref={containerRef} className="absolute inset-0" />

      {/* rail izquierdo */}
      <div className="absolute left-0 top-0 z-[1000] flex h-full flex-col gap-1 bg-brand/95 p-2 text-white shadow-lg">
        <Link href="/" title="Inicio" className="grid size-11 place-items-center rounded-lg hover:bg-white/15">
          <ArrowLeft className="size-5" />
        </Link>
        <button
          title="Buscar"
          onClick={() => setPanel((p) => (p === "search" ? null : "search"))}
          className={cn("grid size-11 place-items-center rounded-lg hover:bg-white/15", panel === "search" && "bg-white/20")}
        >
          <Search className="size-5" />
        </button>
        <button
          title="Categorías"
          onClick={() => setPanel((p) => (p === "cats" ? null : "cats"))}
          className={cn("grid size-11 place-items-center rounded-lg hover:bg-white/15", panel === "cats" && "bg-white/20")}
        >
          <SlidersHorizontal className="size-5" />
        </button>
        {isAuthenticated && (
          <button
            title="Mis favoritos en el mapa"
            onClick={toggleFavsEnMapa}
            className={cn("grid size-11 place-items-center rounded-lg hover:bg-white/15", showFavs && "bg-white/20")}
          >
            <Star className={cn("size-5", showFavs && "fill-current")} />
          </button>
        )}
        <button
          title="Mi ubicación"
          onClick={irAMiUbicacion}
          className="grid size-11 place-items-center rounded-lg hover:bg-white/15"
        >
          <LocateFixed className="size-5" />
        </button>
        <Link href="/lugares" title="Listado" className="grid size-11 place-items-center rounded-lg text-xs hover:bg-white/15">
          Lista
        </Link>
      </div>

      {/* panel */}
      {panel && (
        <div className="absolute left-16 top-0 z-[1000] flex h-full w-80 flex-col bg-white shadow-2xl">
          <div className="flex items-center justify-between border-b bg-brand px-4 py-3 text-white">
            <h2 className="font-semibold">{panel === "cats" ? "Filtrar categorías" : "Buscar lugares"}</h2>
            <button onClick={() => setPanel(null)}>
              <X className="size-5" />
            </button>
          </div>

          {panel === "cats" ? (
            <>
              <div className="flex-1 overflow-y-auto p-3">
                {categorias.map(([cat, icono]) => (
                  <label key={cat} className="flex cursor-pointer items-center gap-2 rounded-lg px-2 py-2 hover:bg-accent">
                    <input
                      type="checkbox"
                      checked={activeCats.current.has(cat)}
                      onChange={() => toggleCat(cat)}
                      className="accent-[var(--brand)]"
                    />
                    <span className="text-lg">{icono}</span>
                    <span className="text-sm">{cat}</span>
                    <span className="ml-auto text-xs text-muted-foreground">
                      {markersByCat.current.get(cat)?.length ?? 0}
                    </span>
                  </label>
                ))}
              </div>
              <button onClick={limpiarFiltros} className="border-t p-3 text-sm font-medium text-brand hover:bg-accent">
                🔄 Limpiar filtros
              </button>
            </>
          ) : (
            <div className="flex flex-1 flex-col">
              <div className="p-3">
                <input
                  autoFocus
                  value={query}
                  onChange={(e) => setQuery(e.target.value)}
                  placeholder="Nombre, categoría o departamento…"
                  className="w-full rounded-lg border px-3 py-2 text-sm outline-none focus:border-brand"
                />
              </div>
              <div className="flex-1 overflow-y-auto">
                {resultados.map((l) => (
                  <button
                    key={l.id}
                    onClick={() => irALugar(l)}
                    className="flex w-full items-start gap-2 border-b px-3 py-2 text-left hover:bg-accent"
                  >
                    <span className="text-lg">{l.icono}</span>
                    <span>
                      <span className="block text-sm font-medium">{l.nombre}</span>
                      <span className="block text-xs text-muted-foreground">
                        {l.categoria} · {l.departamento}
                      </span>
                    </span>
                  </button>
                ))}
                {query.length >= 2 && resultados.length === 0 && (
                  <p className="p-4 text-sm text-muted-foreground">Sin resultados.</p>
                )}
              </div>
            </div>
          )}
        </div>
      )}
    </div>
  );
}

function popupHtml(l: MapaLugar) {
  const img = lugarImg(l.imagen);
  return `<div class="cm-popup">
    <img class="cm-popup-img" src="${img}" alt="" onerror="this.style.display='none'"/>
    <h4>${escapeHtml(l.nombre)}</h4>
    ${l.descripcion ? `<p>${escapeHtml(l.descripcion.slice(0, 120))}</p>` : ""}
    <div class="cm-popup-actions">
      <button class="cm-btn-route" data-lat="${l.lat}" data-lng="${l.lng}">🧭 Ir aquí</button>
      <a class="cm-btn-detail" href="/lugares/${l.id}">ℹ️ Ver detalle</a>
    </div>
  </div>`;
}

function escapeHtml(s: string) {
  return s.replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[c]!);
}
