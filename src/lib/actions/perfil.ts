"use server";

import { revalidatePath } from "next/cache";
import { z } from "zod";
import { prisma } from "@/lib/prisma";
import { createClient } from "@/lib/supabase/server";
import { getSessionUser } from "@/lib/auth";
import { passwordSchema } from "@/lib/validations/auth";

type Res = { ok: true } | { ok: false; error: string };

export async function actualizarPerfil(input: {
  nombre?: string;
  telefono?: string;
  bio?: string;
}): Promise<Res> {
  const session = await getSessionUser();
  if (!session) return { ok: false, error: "No autenticado" };

  const schema = z.object({
    nombre: z.string().trim().min(3).max(100).optional(),
    telefono: z.string().trim().max(30).optional(),
    bio: z.string().trim().max(500).optional(),
  });
  const parsed = schema.safeParse(input);
  if (!parsed.success) return { ok: false, error: parsed.error.issues[0].message };

  await prisma.perfil.update({ where: { id: session.id }, data: parsed.data });
  revalidatePath("/perfil");
  revalidatePath(`/perfil/${session.id}`);
  return { ok: true };
}

export async function actualizarAvatar(url: string): Promise<Res> {
  const session = await getSessionUser();
  if (!session) return { ok: false, error: "No autenticado" };
  if (!/^https:\/\/res\.cloudinary\.com\//.test(url)) return { ok: false, error: "URL inválida" };

  await prisma.perfil.update({ where: { id: session.id }, data: { imagenPerfil: url } });
  revalidatePath("/perfil");
  return { ok: true };
}

export async function cambiarPassword(input: { actual: string; nueva: string }): Promise<Res> {
  const session = await getSessionUser();
  if (!session) return { ok: false, error: "No autenticado" };

  const parsed = passwordSchema.safeParse(input.nueva);
  if (!parsed.success) return { ok: false, error: parsed.error.issues[0].message };

  const supabase = await createClient();
  // Reverificar la contraseña actual.
  const { error: signInErr } = await supabase.auth.signInWithPassword({
    email: session.email,
    password: input.actual,
  });
  if (signInErr) return { ok: false, error: "La contraseña actual es incorrecta" };

  const { error } = await supabase.auth.updateUser({ password: input.nueva });
  if (error) return { ok: false, error: "No se pudo actualizar la contraseña" };
  return { ok: true };
}

export async function guardarPrivacidad(input: {
  perfilPublico: boolean;
  favoritosPublicos: boolean;
  comentariosPublicos: boolean;
  mostrarEstadisticas: boolean;
}): Promise<Res> {
  const session = await getSessionUser();
  if (!session) return { ok: false, error: "No autenticado" };

  await prisma.configuracionPrivacidad.upsert({
    where: { idUsuario: session.id },
    create: { idUsuario: session.id, ...input },
    update: input,
  });
  revalidatePath("/perfil");
  revalidatePath(`/perfil/${session.id}`);
  return { ok: true };
}

/** Toggle idempotente de seguimiento. */
export async function toggleSeguir(idObjetivo: string): Promise<
  { ok: true; siguiendo: boolean } | { ok: false; error: string }
> {
  const session = await getSessionUser();
  if (!session) return { ok: false, error: "No autenticado" };
  if (session.id === idObjetivo) return { ok: false, error: "No podés seguirte a vos mismo" };

  const objetivo = await prisma.perfil.findUnique({ where: { id: idObjetivo }, select: { estado: true } });
  if (!objetivo || objetivo.estado !== "activo") return { ok: false, error: "Usuario no disponible" };

  const existing = await prisma.seguidor.findUnique({
    where: { idSeguidor_idSeguido: { idSeguidor: session.id, idSeguido: idObjetivo } },
  });

  if (existing) {
    await prisma.seguidor.delete({ where: { id: existing.id } });
    revalidatePath(`/perfil/${idObjetivo}`);
    return { ok: true, siguiendo: false };
  }
  await prisma.seguidor.create({ data: { idSeguidor: session.id, idSeguido: idObjetivo } });
  revalidatePath(`/perfil/${idObjetivo}`);
  return { ok: true, siguiendo: true };
}
