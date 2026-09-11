import type { Metadata } from "next";
import { requireUser } from "@/lib/auth";
import { prisma } from "@/lib/prisma";
import { avatarImg } from "@/lib/images";
import { MensajesClient } from "@/components/mensajes/mensajes-client";

export const metadata: Metadata = { title: "Mensajes" };

type SP = Promise<{ chat?: string }>;

export default async function MensajesPage({ searchParams }: { searchParams: SP }) {
  const session = await requireUser();
  const { chat } = await searchParams;

  let inicial: { id: string; nombre: string; imagen: string } | null = null;
  if (chat && chat !== session.id) {
    const u = await prisma.perfil.findUnique({ where: { id: chat }, select: { id: true, nombre: true, imagenPerfil: true } });
    if (u) inicial = { id: u.id, nombre: u.nombre, imagen: avatarImg(u.imagenPerfil, u.nombre) };
  }

  return <MensajesClient chatInicial={inicial} />;
}
