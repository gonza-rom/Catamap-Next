import { Star, MessageCircle, PlusCircle, Sparkles, Compass, Award, Trophy, Medal, type LucideIcon } from "lucide-react";

function normalize(s: string): string {
  return s
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase()
    .trim();
}

const RULES: [string, LucideIcon][] = [
  ["novato", Star],
  ["critic", MessageCircle],
  ["contribuyente", PlusCircle],
  ["experto", Sparkles],
  ["guia", Compass],
  ["colaborador", Award],
  ["leyenda", Trophy],
];

/** Ícono Lucide para una insignia, a partir de su nombre. */
export function getInsigniaIcon(nombre: string | null | undefined): LucideIcon {
  if (!nombre) return Medal;
  const n = normalize(nombre);
  for (const [keyword, Icon] of RULES) {
    if (n.includes(keyword)) return Icon;
  }
  return Medal;
}
