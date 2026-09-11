"use server";

import { revalidatePath } from "next/cache";
import { prisma } from "@/lib/prisma";
import { getSessionUser } from "@/lib/auth";
import { checkFavoritoBadges } from "@/lib/badges";

export type ToggleResult =
  | { ok: true; favorito: boolean }
  | { ok: false; error: string };

export async function toggleFavorito(idLugar: number): Promise<ToggleResult> {
  const session = await getSessionUser();
  if (!session) return { ok: false, error: "Iniciá sesión para guardar favoritos" };

  const lugar = await prisma.lugar.findUnique({ where: { id: idLugar }, select: { id: true } });
  if (!lugar) return { ok: false, error: "Lugar no encontrado" };

  const existing = await prisma.favorito.findUnique({
    where: { idUsuario_idLugar: { idUsuario: session.id, idLugar } },
  });

  if (existing) {
    await prisma.favorito.delete({ where: { id: existing.id } });
    revalidatePath("/perfil");
    revalidatePath(`/lugares/${idLugar}`);
    return { ok: true, favorito: false };
  }

  await prisma.favorito.create({ data: { idUsuario: session.id, idLugar } });
  await checkFavoritoBadges(session.id);
  revalidatePath("/perfil");
  revalidatePath(`/lugares/${idLugar}`);
  return { ok: true, favorito: true };
}
