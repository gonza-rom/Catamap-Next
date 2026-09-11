/** Imagen de un lugar con fallback al placeholder. */
export function lugarImg(imagen: string | null | undefined): string {
  return imagen && imagen.trim() ? imagen : "/img/placeholder.webp";
}

/** Avatar de un usuario con fallback a ui-avatars. */
export function avatarImg(imagen: string | null | undefined, nombre: string): string {
  if (imagen && imagen.trim()) return imagen;
  return `https://ui-avatars.com/api/?name=${encodeURIComponent(nombre)}&background=667eea&color=fff`;
}
