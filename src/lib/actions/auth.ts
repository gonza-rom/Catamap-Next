"use server";

import { revalidatePath } from "next/cache";
import { createClient } from "@/lib/supabase/server";
import { createAdminClient } from "@/lib/supabase/admin";
import { prisma } from "@/lib/prisma";
import { loginSchema, registerSchema } from "@/lib/validations/auth";
import { rateLimit } from "@/lib/rate-limit";

export type ActionResult = { ok: true } | { ok: false; error: string };

export async function loginAction(input: unknown): Promise<ActionResult> {
  // Generoso a propósito: no debe frenar a un salón lleno de gente entrando a la vez,
  // solo un script probando contraseñas en loop.
  const limited = await rateLimit("login", 40, 5 * 60 * 1000);
  if (!limited.ok) {
    return { ok: false, error: `Demasiados intentos. Probá de nuevo en ${limited.retryAfterSec}s.` };
  }

  const parsed = loginSchema.safeParse(input);
  if (!parsed.success) return { ok: false, error: parsed.error.issues[0].message };

  const supabase = await createClient();
  const { data, error } = await supabase.auth.signInWithPassword(parsed.data);
  if (error || !data.user) return { ok: false, error: "Email o contraseña incorrectos" };

  // Réplica de la regla PHP: sólo usuarios activos pueden entrar.
  const perfil = await prisma.perfil.findUnique({ where: { id: data.user.id } });
  if (!perfil || perfil.estado !== "activo") {
    await supabase.auth.signOut();
    return { ok: false, error: "Tu cuenta está suspendida o inactiva. Contactá a un administrador." };
  }

  await prisma.perfil.update({
    where: { id: data.user.id },
    data: { ultimoAcceso: new Date() },
  });

  revalidatePath("/", "layout");
  return { ok: true };
}

export async function registerAction(input: unknown): Promise<ActionResult> {
  // Generoso a propósito: pensado para una presentación con mucha gente registrándose
  // desde el mismo Wi-Fi (misma IP pública), no para limitar el uso normal.
  const limited = await rateLimit("register", 60, 10 * 60 * 1000);
  if (!limited.ok) {
    return { ok: false, error: `Demasiados registros seguidos. Probá de nuevo en ${limited.retryAfterSec}s.` };
  }

  const parsed = registerSchema.safeParse(input);
  if (!parsed.success) return { ok: false, error: parsed.error.issues[0].message };
  const { nombre, email, password } = parsed.data;

  const admin = createAdminClient();
  const { data, error } = await admin.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
    user_metadata: { nombre },
  });

  if (error || !data.user) {
    const msg = error?.message?.toLowerCase().includes("already")
      ? "El email ya está registrado"
      : "No se pudo crear la cuenta";
    return { ok: false, error: msg };
  }

  await prisma.perfil.create({
    data: {
      id: data.user.id,
      nombre,
      rol: "usuario",
      estado: "activo",
      privacidad: { create: {} },
    },
  });

  // Auto-login (igual que el PHP).
  const supabase = await createClient();
  const { error: signInError } = await supabase.auth.signInWithPassword({ email, password });
  if (signInError) return { ok: false, error: "Cuenta creada. Iniciá sesión para continuar." };

  revalidatePath("/", "layout");
  return { ok: true };
}

export async function logoutAction() {
  const supabase = await createClient();
  await supabase.auth.signOut();
  revalidatePath("/", "layout");
}
