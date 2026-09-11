import { getCategoryIcon } from "@/lib/category-icons";

/** Ícono Lucide correspondiente a una categoría (por nombre). */
export function CategoryIcon({
  nombre,
  className,
}: {
  nombre: string | null | undefined;
  className?: string;
}) {
  const Icon = getCategoryIcon(nombre);
  return <Icon className={className} />;
}
