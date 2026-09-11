"use server";

import { revalidatePath } from "next/cache";
import { z } from "zod";
import { prisma } from "@/lib/prisma";
import { getSessionUser } from "@/lib/auth";
import { checkSugerenciaBadges } from "@/lib/badges";

const schema = z.object({
  nombre: z.string().trim().min(3).max(255),
  descripcion: z.string().trim().min(50, "Contá al menos 50 caracteres").max(2000),
  direccion: z.string().trim().max(255).optional().or(z.literal("")),
  lat: z.number().refine((v) => v !== 0, "Marcá la ubicación en el mapa"),
  lng: z.number().refine((v) => v !== 0, "Marcá la ubicación en el mapa"),
  idCategoria: z.number().int().positive("Elegí una categoría"),
  idDepartamento: z.number().int().positive("Elegí un departamento"),
  imagen: z.string().url().optional().or(z.literal("")),
});

export type SugerenciaResult = { ok: true; id: number } | { ok: false; error: string };

export async function crearSugerencia(input: unknown): Promise<SugerenciaResult> {
  const session = await getSessionUser();
  if (!session) return { ok: false, error: "Iniciá sesión para sugerir un lugar" };

  const parsed = schema.safeParse(input);
  if (!parsed.success) return { ok: false, error: parsed.error.issues[0].message };
  const d = parsed.data;

  const sug = await prisma.lugarSugerido.create({
    data: {
      idUsuario: session.id,
      nombre: d.nombre,
      descripcion: d.descripcion,
      direccion: d.direccion || null,
      lat: d.lat,
      lng: d.lng,
      idCategoria: d.idCategoria,
      idDepartamento: d.idDepartamento,
      imagen: d.imagen || null,
      estado: "pendiente",
    },
  });

  await checkSugerenciaBadges(session.id);
  revalidatePath("/perfil");
  return { ok: true, id: sug.id };
}
