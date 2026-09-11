import { renderToStaticMarkup } from "react-dom/server";
import { createElement } from "react";
import { getCategoryIcon } from "./category-icons";
import { MapPin, Star, LocateFixed, type LucideIcon } from "lucide-react";

const cache = new Map<string, string>();

/** SVG (string) de un ícono Lucide — para usar en HTML de Leaflet (divIcon/popups). */
export function iconToSvg(Icon: LucideIcon, opts?: { size?: number; color?: string; strokeWidth?: number }) {
  const key = `${Icon.displayName}-${opts?.size}-${opts?.color}-${opts?.strokeWidth}`;
  const cached = cache.get(key);
  if (cached) return cached;
  const svg = renderToStaticMarkup(
    createElement(Icon, {
      size: opts?.size ?? 22,
      color: opts?.color ?? "currentColor",
      strokeWidth: opts?.strokeWidth ?? 2.25,
    }),
  );
  cache.set(key, svg);
  return svg;
}

/** SVG del ícono correspondiente a una categoría (cacheado por nombre). */
export function categoryIconSvg(nombre: string | null | undefined, opts?: { size?: number; color?: string }) {
  const key = `cat-${nombre}-${opts?.size}-${opts?.color}`;
  const cached = cache.get(key);
  if (cached) return cached;
  const svg = iconToSvg(getCategoryIcon(nombre), opts);
  cache.set(key, svg);
  return svg;
}

export { MapPin, Star, LocateFixed };
