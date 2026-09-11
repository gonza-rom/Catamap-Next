import {
  Church,
  Mountain,
  MountainSnow,
  Waves,
  Landmark,
  Droplets,
  Droplet,
  Home,
  Pickaxe,
  Flame,
  Eye,
  TreePine,
  Route,
  Bird,
  Gem,
  PartyPopper,
  Castle,
  Telescope,
  UtensilsCrossed,
  Sun,
  BedDouble,
  Car,
  TentTree,
  Info,
  Flag,
  Warehouse,
  Tent,
  Flower2,
  HelpCircle,
  MapPin,
  type LucideIcon,
} from "lucide-react";

/** Quita tildes y pasa a minúsculas para matchear nombres de forma tolerante. */
function normalize(s: string): string {
  return s
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase()
    .trim();
}

/**
 * Reglas ordenadas: la primera cuyo `keyword` aparezca en el nombre normalizado de la
 * categoría gana. Cubre las 30 categorías del dataset original y es tolerante a nombres
 * nuevos parecidos (ej. "Cascadas" matchea "cascada").
 */
const RULES: [string, LucideIcon][] = [
  ["iglesia", Church],
  ["capilla", Church],
  ["cascada", Droplet],
  ["cerro", MountainSnow],
  ["montan", Mountain],
  ["rio", Waves],
  ["laguna", Waves],
  ["museo", Landmark],
  ["cultura", Castle],
  ["arqueolog", Castle],
  ["dique", Droplets],
  ["pueblo", Home],
  ["mina", Pickaxe],
  ["terma", Flame],
  ["mirador", Eye],
  ["parque", TreePine],
  ["ruta", Route],
  ["reserva", Bird],
  ["cueva", Gem],
  ["fiesta", PartyPopper],
  ["evento", PartyPopper],
  ["observator", Telescope],
  ["gastronom", UtensilsCrossed],
  ["desierto", Sun],
  ["hotel", BedDouble],
  ["motel", Car],
  ["camping", TentTree],
  ["informacion", Info],
  ["hito", Flag],
  ["frontera", Flag],
  ["fronterizo", Flag],
  ["cabana", Warehouse],
  ["refugio", Tent],
  ["plaza", Flower2],
  ["otro", HelpCircle],
];

/** Icono de Lucide para una categoría, a partir de su nombre. */
export function getCategoryIcon(nombre: string | null | undefined): LucideIcon {
  if (!nombre) return MapPin;
  const n = normalize(nombre);
  for (const [keyword, Icon] of RULES) {
    if (n.includes(keyword)) return Icon;
  }
  return MapPin;
}

export { MapPin as DefaultCategoryIcon };
