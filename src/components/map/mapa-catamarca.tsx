"use client";

import "leaflet/dist/leaflet.css";
import "leaflet.markercluster/dist/MarkerCluster.css";
import "leaflet.markercluster/dist/MarkerCluster.Default.css";
import L from "./leaflet-global"; // debe importarse antes que "leaflet.markercluster"
import "leaflet.markercluster";
import "./map-styles.css";
import { useEffect, useMemo, useRef, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { toast } from "sonner";
import {
  Search,
  SlidersHorizontal,
  LocateFixed,
  Star,
  X,
  ArrowLeft,
  Rows3,
  Navigation,
  Navigation2,
  XCircle,
  Info,
  ExternalLink,
} from "lucide-react";
import Link from "next/link";
import { categoryPin, userIcon, favIcon } from "./icons";
import { categoryIconSvg, iconToSvg } from "@/lib/icon-svg";
import { CategoryIcon } from "@/components/category-icon";
import type { MapaLugar } from "@/lib/data/mapa";
import { lugarImg } from "@/lib/images";
import { cn } from "@/lib/utils";
import { loadMapState, saveMapState } from "./map-state";

const TILE_LAYERS: { name: string; url: string }[] = [
  { name: "Calles", url: "https://tile.openstreetmap.org/{z}/{x}/{y}.png" },
  { name: "Moderno", url: "https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png" },
  {
    name: "Terreno",
    url: "https://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer/tile/{z}/{y}/{x}",
  },
  { name: "Claro", url: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png" },
];

const railLabelClass = "text-[9px] font-medium leading-none sm:text-[10px]";

function railBtnClass(active?: boolean) {
  return cn(
    "flex w-14 shrink-0 flex-col items-center justify-center gap-1 rounded-lg px-1 py-1.5 text-white hover:bg-white/15 sm:w-full sm:py-2",
    active && "bg-white/20",
  );
}

function haversine(a: L.LatLng, bLat: number, bLng: number) {
  const R = 6371000;
  const dLat = ((bLat - a.lat) * Math.PI) / 180;
  const dLng = ((bLng - a.lng) * Math.PI) / 180;
  const s =
    Math.sin(dLat / 2) ** 2 +
    Math.cos((a.lat * Math.PI) / 180) * Math.cos((bLat * Math.PI) / 180) * Math.sin(dLng / 2) ** 2;
  return 2 * R * Math.asin(Math.sqrt(s));
}

type Props = {
  lugares: MapaLugar[];
  favoritos: number[];
  isAuthenticated: boolean;
};

export default function MapaCatamarca({ lugares, favoritos, isAuthenticated }: Props) {
  const mapRef = useRef<L.Map | null>(null);
  const containerRef = useRef<HTMLDivElement>(null);
  const clusterRef = useRef<L.MarkerClusterGroup | null>(null);
  const markersByCat = useRef<Map<string, L.Marker[]>>(new Map());
  const activeCats = useRef<Set<string>>(new Set());
  const userLatLng = useRef<L.LatLng | null>(null);
  const userMarker = useRef<L.Marker | null>(null);
  const routeLayer = useRef<L.GeoJSON | null>(null);
  const favLayer = useRef<L.LayerGroup | null>(null);
  const navTarget = useRef<{ lat: number; lng: number } | null>(null);
  const watchId = useRef<number | null>(null);
  const showFavsRef = useRef(false);
  const saveTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

  const router = useRouter();
  const params = useSearchParams();
  const favSet = useMemo(() => new Set(favoritos), [favoritos]);

  const [panel, setPanel] = useState<"cats" | "search" | null>(null);
  const [query, setQuery] = useState("");
  const [showFavs, setShowFavs] = useState(false);
  const [nav, setNav] = useState<{ distancia: number; duracion: number } | null>(null);
  const [, forceRerender] = useState(0);

  const categorias = useMemo(() => {
    const set = new Set<string>();
    for (const l of lugares) set.add(l.categoria);
    return [...set].sort((a, b) => a.localeCompare(b));
  }, [lugares]);

  function persist() {
    const map = mapRef.current;
    if (!map) return;
    const c = map.getCenter();
    saveMapState({
      cats: [...activeCats.current],
      favs: showFavsRef.current,
      center: [c.lat, c.lng],
      zoom: map.getZoom(),
    });
  }

  // ── init map ──
  useEffect(() => {
    if (mapRef.current || !containerRef.current) return;
    const saved = loadMapState();
    const map = L.map(containerRef.current, { zoomControl: false, attributionControl: false }).setView(
      saved?.center ?? [-28.47, -65.79],
      saved?.zoom ?? 7,
    );
    mapRef.current = map;
    L.control.zoom({ position: "bottomright" }).addTo(map);

    const baseLayers: Record<string, L.TileLayer> = {};
    TILE_LAYERS.forEach((t, i) => {
      const layer = L.tileLayer(t.url, { maxZoom: 18 });
      baseLayers[t.name] = layer;
      if (i === 0) layer.addTo(map);
    });
    L.control.layers(baseLayers, undefined, { position: "topright" }).addTo(map);
    L.control.attribution({ position: "bottomleft", prefix: false }).addAttribution("© OpenStreetMap").addTo(map);

    // agrupa marcadores cercanos en burbujas con contador — mucho más rápido y legible
    // con miles de puntos que dibujarlos todos sueltos.
    const cluster = L.markerClusterGroup({
      maxClusterRadius: 55,
      disableClusteringAtZoom: 16,
      spiderfyOnMaxZoom: true,
      showCoverageOnHover: false,
      iconCreateFunction: (c) => {
        const count = c.getChildCount();
        const size = count < 10 ? 34 : count < 50 ? 40 : count < 200 ? 48 : 56;
        return L.divIcon({
          html: `<span class="cm-cluster-badge" style="width:${size}px;height:${size}px;font-size:${size < 40 ? 12 : 14}px">${count}</span>`,
          className: "cm-cluster",
          iconSize: L.point(size, size),
        });
      },
    });
    cluster.addTo(map);
    clusterRef.current = cluster;

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
                    .map(
                      (l) =>
                        `<a href="/lugares/${l.id}" class="cm-popup-list-item">${categoryIconSvg(l.categoria, { size: 14 })}${escapeHtml(l.nombre)}</a>`,
                    )
                    .join("") +
                  (del.length > 40 ? `<p>…y ${del.length - 40} más</p>` : "") +
                  `</div>`
                : `<div class="cm-popup"><h4>${nombre}</h4><p>Sin lugares cargados</p></div>`;
              L.popup({ maxHeight: 260 }).setLatLng((lyr as L.Polygon).getBounds().getCenter()).setContent(html).openOn(map);
            });
          },
        }).addTo(map);
        try {
          map.setMaxBounds(layer.getBounds().pad(0.3));
          map.setMinZoom(map.getBoundsZoom(layer.getBounds()) - 1);
          if (!saved) map.fitBounds(layer.getBounds(), { padding: [20, 20] });
        } catch {}
      })
      .catch(() => {});

    // marcadores por categoría (lazy: se crean pero no se agregan hasta activar la categoría).
    // el ícono se arma una sola vez por categoría y se reutiliza en todos sus marcadores.
    const iconByCat = new Map<string, L.DivIcon>();
    for (const l of lugares) {
      let icon = iconByCat.get(l.categoria);
      if (!icon) {
        icon = categoryPin(l.categoria);
        iconByCat.set(l.categoria, icon);
      }
      // el contenido del popup se arma recién al abrirlo (no en la carga inicial)
      const m = L.marker([l.lat, l.lng], { icon }).bindPopup(() => popupHtml(l), {
        maxWidth: 260,
        className: "cm-popup-wrapper",
      });
      const arr = markersByCat.current.get(l.categoria) ?? [];
      arr.push(m);
      markersByCat.current.set(l.categoria, arr);
    }

    // restaurar filtros/vista guardados de una visita anterior
    if (saved?.cats?.length) {
      for (const cat of saved.cats) {
        activeCats.current.add(cat);
        (markersByCat.current.get(cat) ?? []).forEach((mk) => cluster.addLayer(mk));
      }
      forceRerender((n) => n + 1);
    }
    if (saved?.favs) setTimeout(() => toggleFavsEnMapa(), 0);

    // delegación de clicks en popups (botón "Ruta" = navegación dentro de la app)
    map.on("popupopen", (e) => {
      const node = (e.popup as L.Popup).getElement();
      node?.querySelector<HTMLButtonElement>(".cm-btn-route")?.addEventListener("click", (ev) => {
        const t = ev.currentTarget as HTMLElement;
        iniciarNavegacion(Number(t.dataset.lat), Number(t.dataset.lng));
      });
    });

    map.on("moveend", () => {
      if (saveTimer.current) clearTimeout(saveTimer.current);
      saveTimer.current = setTimeout(persist, 400);
    });

    // geolocalización
    map.locate({ setView: false, maxZoom: 14 });
    map.on("locationfound", (e) => {
      userLatLng.current = e.latlng;
      if (userMarker.current) userMarker.current.setLatLng(e.latlng);
      else
        userMarker.current = L.marker(e.latlng, { icon: userIcon(), zIndexOffset: 1000 })
          .addTo(map)
          .bindPopup("Estás acá");
    });

    return () => {
      if (watchId.current != null) navigator.geolocation.clearWatch(watchId.current);
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
    if (!activeCats.current.has(l.categoria)) toggleCat(l.categoria, true);
    map.flyTo([l.lat, l.lng], 15, { duration: 1 });
    const tmp = L.marker([l.lat, l.lng], { icon: categoryPin(l.categoria) }).addTo(map).bindPopup(popupHtml(l)).openPopup();
    setTimeout(() => map.removeLayer(tmp), 20000);
    router.replace("/mapa");
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [params, lugares]);

  function toggleCat(cat: string, force?: boolean) {
    const cluster = clusterRef.current;
    if (!cluster) return;
    const on = force ?? !activeCats.current.has(cat);
    const markers = markersByCat.current.get(cat) ?? [];
    if (on) {
      activeCats.current.add(cat);
      markers.forEach((m) => cluster.addLayer(m));
    } else {
      activeCats.current.delete(cat);
      markers.forEach((m) => cluster.removeLayer(m));
    }
    forceRerender((n) => n + 1);
    persist();
  }

  function limpiarFiltros() {
    const cluster = clusterRef.current;
    if (!cluster) return;
    for (const cat of [...activeCats.current]) {
      (markersByCat.current.get(cat) ?? []).forEach((m) => cluster.removeLayer(m));
    }
    activeCats.current.clear();
    forceRerender((n) => n + 1);
    persist();
  }

  // ── navegación dentro de la app: calcula la ruta (ORS) y sigue al usuario ──
  function iniciarNavegacion(lat: number, lng: number) {
    if (!userLatLng.current) {
      toast.error("Activá tu ubicación para trazar la ruta");
      return;
    }
    if (navTarget.current && navTarget.current.lat === lat && navTarget.current.lng === lng) {
      detenerNavegacion();
      return;
    }
    detenerNavegacion();
    navTarget.current = { lat, lng };
    calcularRuta(lat, lng);
  }

  async function calcularRuta(lat: number, lng: number) {
    const map = mapRef.current;
    if (!map || !userLatLng.current) return;
    const id = toast.loading("Calculando ruta…");
    try {
      const r = await fetch("/api/ruta", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ from: [userLatLng.current.lng, userLatLng.current.lat], to: [lng, lat] }),
      });
      const data = await r.json();
      if (!r.ok || !data.geometry) throw new Error(data.error || "Error");
      if (routeLayer.current) map.removeLayer(routeLayer.current);
      routeLayer.current = L.geoJSON(data.geometry, { style: { color: "#4CAF50", weight: 5 } }).addTo(map);
      setNav({ distancia: data.distancia, duracion: data.duracion });
      map.fitBounds(routeLayer.current.getBounds(), { padding: [60, 120] });
      toast.success("Ruta calculada — siguiendo tu ubicación", { id });
      setTimeout(iniciarSeguimientoGPS, 1000);
    } catch (e) {
      toast.error(e instanceof Error ? e.message : "No se pudo calcular la ruta", { id });
      navTarget.current = null;
    }
  }

  function iniciarSeguimientoGPS() {
    const map = mapRef.current;
    if (!map || !navigator.geolocation) return;
    if (watchId.current != null) navigator.geolocation.clearWatch(watchId.current);
    watchId.current = navigator.geolocation.watchPosition(
      (pos) => {
        const ll = L.latLng(pos.coords.latitude, pos.coords.longitude);
        userLatLng.current = ll;
        if (userMarker.current) userMarker.current.setLatLng(ll);
        else userMarker.current = L.marker(ll, { icon: userIcon(), zIndexOffset: 1000 }).addTo(map);
        map.panTo(ll, { animate: true, duration: 0.5 });
        if (map.getZoom() < 16) map.setZoom(17, { animate: true });
        if (navTarget.current) {
          const dist = haversine(ll, navTarget.current.lat, navTarget.current.lng);
          setNav((n) => (n ? { ...n, distancia: dist } : n));
          if (dist < 40) {
            toast.success("¡Llegaste a destino!");
            detenerNavegacion();
          }
        }
      },
      () => toast.error("No se pudo seguir tu ubicación en vivo"),
      { enableHighAccuracy: true, maximumAge: 2000, timeout: 10000 },
    );
  }

  function detenerNavegacion() {
    if (watchId.current != null) {
      navigator.geolocation.clearWatch(watchId.current);
      watchId.current = null;
    }
    if (routeLayer.current) {
      mapRef.current?.removeLayer(routeLayer.current);
      routeLayer.current = null;
    }
    navTarget.current = null;
    setNav(null);
  }

  function irAMiUbicacion() {
    const map = mapRef.current;
    if (!map) return;
    if (userLatLng.current) map.flyTo(userLatLng.current, 15);
    else map.locate({ setView: true, maxZoom: 14 });
  }

  function toggleFavsEnMapa() {
    const map = mapRef.current;
    if (!map) return;
    if (favLayer.current) {
      map.removeLayer(favLayer.current);
      favLayer.current = null;
      setShowFavs(false);
      showFavsRef.current = false;
      persist();
      return;
    }
    const favs = lugares.filter((l) => favSet.has(l.id));
    if (!favs.length) {
      toast.info("No tenés favoritos todavía");
      return;
    }
    const group = L.layerGroup(favs.map((l) => L.marker([l.lat, l.lng], { icon: favIcon() }).bindPopup(popupHtml(l)))).addTo(
      map,
    );
    favLayer.current = group;
    setShowFavs(true);
    showFavsRef.current = true;
    persist();
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

      {/* barra de navegación activa (ruta dentro de la app) */}
      {nav && (
        <div className="absolute inset-x-2 bottom-[4.5rem] z-[1000] flex items-center gap-3 rounded-2xl bg-white p-3 shadow-2xl sm:inset-x-auto sm:bottom-4 sm:left-20 sm:right-4 sm:max-w-sm">
          <div className="grid size-10 shrink-0 place-items-center rounded-full bg-green-600 text-white">
            <Navigation2 className="size-5" />
          </div>
          <div className="min-w-0 flex-1">
            <p className="text-lg font-bold leading-none">
              {nav.distancia >= 1000 ? `${(nav.distancia / 1000).toFixed(1)} km` : `${Math.round(nav.distancia)} m`}
            </p>
            <p className="truncate text-xs text-muted-foreground">
              ~{Math.max(1, Math.round(nav.duracion / 60))} min · siguiendo tu ubicación
            </p>
          </div>
          <button
            onClick={detenerNavegacion}
            title="Salir de la navegación"
            className="grid size-9 shrink-0 place-items-center rounded-full bg-red-500 text-white hover:bg-red-600"
          >
            <XCircle className="size-5" />
          </button>
        </div>
      )}

      {/* rail de accesos: cada botón muestra ícono + etiqueta para que se entienda sin tocar */}
      <div
        className={cn(
          "absolute inset-x-0 bottom-0 z-[1000] flex h-16 items-stretch justify-around gap-0.5 overflow-x-auto bg-brand/95 px-1 text-white shadow-lg",
          "[padding-bottom:env(safe-area-inset-bottom)]",
          "sm:inset-x-auto sm:inset-y-0 sm:h-full sm:w-16 sm:flex-col sm:items-center sm:justify-start sm:gap-1 sm:overflow-visible sm:p-2 sm:[padding-bottom:0.5rem]",
        )}
      >
        <Link href="/" className={railBtnClass()}>
          <ArrowLeft className="size-5" />
          <span className={railLabelClass}>Inicio</span>
        </Link>
        <button
          onClick={() => setPanel((p) => (p === "search" ? null : "search"))}
          className={railBtnClass(panel === "search")}
        >
          <Search className="size-5" />
          <span className={railLabelClass}>Buscar</span>
        </button>
        <button onClick={() => setPanel((p) => (p === "cats" ? null : "cats"))} className={railBtnClass(panel === "cats")}>
          <SlidersHorizontal className="size-5" />
          <span className={railLabelClass}>Filtros</span>
        </button>
        {isAuthenticated && (
          <button onClick={toggleFavsEnMapa} className={railBtnClass(showFavs)}>
            <Star className={cn("size-5", showFavs && "fill-current")} />
            <span className={railLabelClass}>Favoritos</span>
          </button>
        )}
        <button onClick={irAMiUbicacion} className={railBtnClass()}>
          <LocateFixed className="size-5" />
          <span className={railLabelClass}>Ubicación</span>
        </button>
        <Link href="/lugares" className={railBtnClass()}>
          <Rows3 className="size-5" />
          <span className={railLabelClass}>Listado</span>
        </Link>
      </div>

      {/* panel: hoja inferior en mobile, panel lateral en desktop */}
      {panel && (
        <div
          className={cn(
            "absolute inset-x-0 bottom-16 z-[1000] flex max-h-[60dvh] flex-col rounded-t-2xl bg-white shadow-2xl",
            "sm:inset-x-auto sm:inset-y-0 sm:bottom-auto sm:left-16 sm:top-0 sm:h-full sm:max-h-none sm:w-80 sm:rounded-none",
          )}
        >
          <div className="flex justify-center pt-1.5 sm:hidden">
            <span className="h-1.5 w-10 rounded-full bg-muted-foreground/30" />
          </div>
          <div className="flex items-center justify-between border-b bg-brand px-4 py-3 text-white">
            <h2 className="font-semibold">{panel === "cats" ? "Filtrar categorías" : "Buscar lugares"}</h2>
            <button onClick={() => setPanel(null)} aria-label="Cerrar">
              <X className="size-5" />
            </button>
          </div>

          {panel === "cats" ? (
            <>
              <div className="flex-1 overflow-y-auto p-3">
                {categorias.map((cat) => (
                  <label key={cat} className="flex cursor-pointer items-center gap-3 rounded-lg px-2 py-2 hover:bg-accent">
                    <input
                      type="checkbox"
                      checked={activeCats.current.has(cat)}
                      onChange={() => toggleCat(cat)}
                      className="accent-[var(--brand)]"
                    />
                    <CategoryIcon nombre={cat} className="size-5 shrink-0 text-brand" />
                    <span className="text-sm">{cat}</span>
                    <span className="ml-auto text-xs text-muted-foreground">
                      {markersByCat.current.get(cat)?.length ?? 0}
                    </span>
                  </label>
                ))}
              </div>
              <button
                onClick={limpiarFiltros}
                className="flex items-center justify-center gap-1.5 border-t p-3 text-sm font-medium text-brand hover:bg-accent"
              >
                <X className="size-4" /> Limpiar filtros
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
                    <CategoryIcon nombre={l.categoria} className="mt-0.5 size-5 shrink-0 text-brand" />
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
  const routeSvg = iconToSvg(Navigation, { size: 14, color: "#fff" });
  const gmapsSvg = iconToSvg(ExternalLink, { size: 14, color: "#fff" });
  const infoSvg = iconToSvg(Info, { size: 14, color: "#fff" });
  const gmapsUrl = `https://www.google.com/maps/dir/?api=1&destination=${l.lat},${l.lng}&travelmode=driving`;
  return `<div class="cm-popup">
    <img class="cm-popup-img" src="${img}" alt="" onerror="this.style.display='none'"/>
    <h4>${escapeHtml(l.nombre)}</h4>
    ${l.descripcion ? `<p>${escapeHtml(l.descripcion.slice(0, 120))}</p>` : ""}
    <div class="cm-popup-actions">
      <button class="cm-btn-route" data-lat="${l.lat}" data-lng="${l.lng}">${routeSvg}Ruta</button>
      <a class="cm-btn-gmaps" href="${gmapsUrl}" target="_blank" rel="noopener noreferrer">${gmapsSvg}Maps</a>
    </div>
    <a class="cm-btn-detail" href="/lugares/${l.id}">${infoSvg}Ver detalle</a>
  </div>`;
}

function escapeHtml(s: string) {
  return s.replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[c]!);
}
