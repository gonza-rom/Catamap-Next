"use server";

import { revalidatePath } from "next/cache";
import { z } from "zod";
import { prisma } from "@/lib/prisma";
import { getSessionUser } from "@/lib/auth";
import { checkComentarioBadges } from "@/lib/badges";

const schema = z.object({
  idLugar: z.number().int().positive(),
  calificacion: z.number().int().min(1).max(5),
  comentario: z.string().trim().min(10, "Mínimo 10 caracteres").max(1000, "Máximo 1000 caracteres"),
});

export type ComentarioResult =
  | { ok: true; pending: true }
  | { ok: false; error: string };

/** Crea o actualiza la reseña del usuario para un lugar. Queda pendiente de moderación. */
export async function guardarComentario(input: unknown): Promise<ComentarioResult> {
  const session = await getSessionUser();
  if (!session) return { ok: false, error: "Iniciá sesión para opinar" };

  const parsed = schema.safeParse(input);
  if (!parsed.success) return { ok: false, error: parsed.error.issues[0].message };
  const { idLugar, calificacion, comentario } = parsed.data;

  const lugar = await prisma.lugar.findUnique({ where: { id: idLugar }, select: { id: true } });
  if (!lugar) return { ok: false, error: "Lugar no encontrado" };

  await prisma.comentario.upsert({
    where: { idUsuario_idLugar: { idUsuario: session.id, idLugar } },
    create: { idLugar, idUsuario: session.id, calificacion, comentario, estado: "pendiente" },
    update: { calificacion, comentario, estado: "pendiente", fechaModificacion: new Date() },
  });

  await checkComentarioBadges(session.id);
  revalidatePath(`/lugares/${idLugar}`);
  return { ok: true, pending: true };
}

export async function eliminarComentario(id: number): Promise<{ ok: boolean; error?: string }> {
  const session = await getSessionUser();
  if (!session) return { ok: false, error: "No autenticado" };

  const res = await prisma.comentario.deleteMany({ where: { id, idUsuario: session.id } });
  if (res.count === 0) return { ok: false, error: "No encontrado o sin permiso" };

  revalidatePath("/perfil");
  return { ok: true };
}
