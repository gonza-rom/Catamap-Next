import { prisma } from "@/lib/prisma";

/**
 * Otorga insignias por umbrales, igual que el proyecto PHP.
 * IDs del catálogo (data/catamap.sql):
 *   1 Explorador Novato   (1er favorito)
 *   2 Crítico             (1er comentario)
 *   3 Contribuyente       (1era sugerencia)
 *   4 Explorador Experto  (10 favoritos)
 *   5 Guía Local          (10 comentarios)
 *   6 Colaborador Activo  (5 sugerencias aprobadas)
 */
async function grant(idUsuario: string, idInsignia: number) {
  await prisma.usuarioInsignia
    .create({ data: { idUsuario, idInsignia } })
    .catch(() => {}); // ya la tiene (PK compuesta)
}

export async function checkFavoritoBadges(idUsuario: string) {
  const count = await prisma.favorito.count({ where: { idUsuario } });
  if (count >= 1) await grant(idUsuario, 1);
  if (count >= 10) await grant(idUsuario, 4);
}

export async function checkComentarioBadges(idUsuario: string) {
  const count = await prisma.comentario.count({ where: { idUsuario } });
  if (count >= 1) await grant(idUsuario, 2);
  if (count >= 10) await grant(idUsuario, 5);
}

export async function checkSugerenciaBadges(idUsuario: string) {
  const total = await prisma.lugarSugerido.count({ where: { idUsuario } });
  if (total >= 1) await grant(idUsuario, 3);
  const aprobadas = await prisma.lugarSugerido.count({
    where: { idUsuario, estado: "aprobado" },
  });
  if (aprobadas >= 5) await grant(idUsuario, 6);
}
