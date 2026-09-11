import L from "leaflet";
import { categoryIconSvg, iconToSvg } from "@/lib/icon-svg";
import { Star, MapPin } from "lucide-react";

/** Pin de mapa (círculo + colita) con el ícono Lucide de la categoría dada. */
export function categoryPin(nombre: string | null | undefined, opts?: { color?: string }) {
  const svg = categoryIconSvg(nombre, { size: 16, color: "#fff" });
  const bg = opts?.color ?? "var(--brand, #e07b39)";
  return L.divIcon({
    className: "cm-marker",
    html: `<span class="cm-marker-badge" style="background:${bg}">${svg}</span><span class="cm-marker-tail" style="border-top-color:${bg}"></span>`,
    iconSize: [30, 40],
    iconAnchor: [15, 40],
    popupAnchor: [0, -38],
  });
}

/** Pin genérico (sin categoría) — mini-mapa de detalle, selector de ubicación. */
export function simplePin(opts?: { color?: string; size?: number }) {
  const size = opts?.size ?? 34;
  const svg = iconToSvg(MapPin, { size: size * 0.6, color: opts?.color ?? "#e07b39", strokeWidth: 2.5 });
  return L.divIcon({
    className: "cm-simple-pin",
    html: svg,
    iconSize: [size, size],
    iconAnchor: [size / 2, size],
    popupAnchor: [0, -size + 2],
  });
}

/** Marcador de ubicación del usuario (punto con pulso). */
export function userIcon() {
  return L.divIcon({
    className: "cm-user-marker",
    html: `<span class="cm-user-dot"></span>`,
    iconSize: [22, 22],
    iconAnchor: [11, 11],
  });
}

/** Marcador de favorito (badge dorado con estrella). */
export function favIcon() {
  const svg = iconToSvg(Star, { size: 15, color: "#fff" });
  return L.divIcon({
    className: "cm-marker",
    html: `<span class="cm-marker-badge" style="background:#d4a017">${svg}</span><span class="cm-marker-tail" style="border-top-color:#d4a017"></span>`,
    iconSize: [30, 40],
    iconAnchor: [15, 40],
    popupAnchor: [0, -38],
  });
}
