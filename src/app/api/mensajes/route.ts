import { NextResponse } from "next/server";
import { z } from "zod";
import { prisma } from "@/lib/prisma";
import { getSessionUser } from "@/lib/auth";

export async function GET(req: Request) {
  const session = await getSessionUser();
  if (!session) return NextResponse.json({ error: "No autenticado" }, { status: 401 });

  const { searchParams } = new URL(req.url);
  const con = searchParams.get("con");

  if (con) {
    // Hilo de conversación con un usuario puntual.
    const mensajes = await prisma.mensaje.findMany({
      where: {
        OR: [
          { idRemitente: session.id, idDestinatario: con },
          { idRemitente: con, idDestinatario: session.id },
        ],
      },
      orderBy: { fechaEnvio: "asc" },
    });

    await prisma.mensaje.updateMany({
      where: { idDestinatario: session.id, idRemitente: con, leido: false },
      data: { leido: true },
    });

    return NextResponse.json({
      mensajes: mensajes.map((m) => ({
        id: m.id,
        mensaje: m.mensaje,
        fechaEnvio: m.fechaEnvio,
        esMio: m.idRemitente === session.id,
      })),
    });
  }

  // Lista de conversaciones.
  const mensajes = await prisma.mensaje.findMany({
    where: { OR: [{ idRemitente: session.id }, { idDestinatario: session.id }] },
    orderBy: { fechaEnvio: "desc" },
    include: {
      remitente: { select: { id: true, nombre: true, imagenPerfil: true } },
      destinatario: { select: { id: true, nombre: true, imagenPerfil: true } },
    },
  });

  const byUser = new Map<
    string,
    { id: string; nombre: string; imagen: string | null; ultimoMensaje: string; fecha: Date; noLeidos: number }
  >();

  for (const m of mensajes) {
    const otro = m.idRemitente === session.id ? m.destinatario : m.remitente;
    const entry = byUser.get(otro.id);
    if (!entry) {
      byUser.set(otro.id, {
        id: otro.id,
        nombre: otro.nombre,
        imagen: otro.imagenPerfil,
        ultimoMensaje: m.mensaje,
        fecha: m.fechaEnvio,
        noLeidos: m.idDestinatario === session.id && !m.leido ? 1 : 0,
      });
    } else if (m.idDestinatario === session.id && !m.leido) {
      entry.noLeidos++;
    }
  }

  return NextResponse.json({ conversaciones: [...byUser.values()] });
}

const sendSchema = z.object({
  idDestinatario: z.string().uuid(),
  mensaje: z.string().trim().min(1).max(1000),
});

export async function POST(req: Request) {
  const session = await getSessionUser();
  if (!session) return NextResponse.json({ error: "No autenticado" }, { status: 401 });

  const body = await req.json().catch(() => null);
  const parsed = sendSchema.safeParse(body);
  if (!parsed.success) return NextResponse.json({ error: parsed.error.issues[0].message }, { status: 400 });
  if (parsed.data.idDestinatario === session.id)
    return NextResponse.json({ error: "No podés enviarte mensajes a vos mismo" }, { status: 400 });

  const destinatario = await prisma.perfil.findUnique({ where: { id: parsed.data.idDestinatario } });
  if (!destinatario) return NextResponse.json({ error: "Destinatario no encontrado" }, { status: 404 });

  const m = await prisma.mensaje.create({
    data: {
      idRemitente: session.id,
      idDestinatario: parsed.data.idDestinatario,
      mensaje: parsed.data.mensaje,
    },
  });

  return NextResponse.json({ id: m.id });
}

export async function DELETE(req: Request) {
  const session = await getSessionUser();
  if (!session) return NextResponse.json({ error: "No autenticado" }, { status: 401 });

  const body = await req.json().catch(() => null);
  const idOtro = body?.idOtroUsuario as string | undefined;
  if (!idOtro) return NextResponse.json({ error: "Falta idOtroUsuario" }, { status: 400 });

  await prisma.mensaje.deleteMany({
    where: {
      OR: [
        { idRemitente: session.id, idDestinatario: idOtro },
        { idRemitente: idOtro, idDestinatario: session.id },
      ],
    },
  });

  return NextResponse.json({ ok: true });
}
