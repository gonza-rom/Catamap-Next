import { cache } from "react";
import { redirect } from "next/navigation";
import { createClient } from "@/lib/supabase/server";
import { prisma } from "@/lib/prisma";
import type { Perfil } from "@/generated/prisma";

/** Usuario de Supabase Auth (o null). Cacheado por request. */
export const getAuthUser = cache(async () => {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  return user;
});

export type SessionUser = {
  id: string;
  email: string;
  perfil: Perfil;
};

/** Usuario + perfil de la DB (o null si no hay sesión / no tiene perfil). */
export const getSessionUser = cache(async (): Promise<SessionUser | null> => {
  const user = await getAuthUser();
  if (!user) return null;
  const perfil = await prisma.perfil.findUnique({ where: { id: user.id } });
  if (!perfil) return null;
  return { id: user.id, email: user.email ?? "", perfil };
});

/** Exige sesión activa y estado activo. Redirige al home si falla. */
export async function requireUser(): Promise<SessionUser> {
  const session = await getSessionUser();
  if (!session) redirect("/?login=1");
  if (session.perfil.estado !== "activo") redirect("/?error=cuenta_inactiva");
  return session;
}

/** Exige rol admin. Redirige si falla. */
export async function requireAdmin(): Promise<SessionUser> {
  const session = await requireUser();
  if (session.perfil.rol !== "admin") redirect("/?error=acceso_denegado");
  return session;
}

export function isAdmin(session: SessionUser | null): boolean {
  return session?.perfil.rol === "admin";
}
