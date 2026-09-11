import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";
import { getSessionUser } from "@/lib/auth";

export async function GET() {
  const session = await getSessionUser();
  if (!session) return NextResponse.json({ total: 0 });
  const total = await prisma.mensaje.count({
    where: { idDestinatario: session.id, leido: false },
  });
  return NextResponse.json({ total });
}
