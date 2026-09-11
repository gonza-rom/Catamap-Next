"use client";

import { useEffect, useRef, useState } from "react";
import Image from "next/image";
import Link from "next/link";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { Send } from "lucide-react";
import { cn } from "@/lib/utils";
import { fechaHora } from "@/lib/format";

type Conversacion = {
  id: string;
  nombre: string;
  imagen: string | null;
  ultimoMensaje: string;
  fecha: string;
  noLeidos: number;
};
type Mensaje = { id: number; mensaje: string; fechaEnvio: string; esMio: boolean };

export function MensajesClient({ chatInicial }: { chatInicial: { id: string; nombre: string; imagen: string } | null }) {
  const qc = useQueryClient();
  const [activo, setActivo] = useState<{ id: string; nombre: string; imagen: string } | null>(chatInicial);
  const [texto, setTexto] = useState("");
  const bottomRef = useRef<HTMLDivElement>(null);

  const { data: conversaciones = [] } = useQuery<Conversacion[]>({
    queryKey: ["conversaciones"],
    queryFn: async () => (await fetch("/api/mensajes")).json().then((d) => d.conversaciones),
    refetchInterval: 5000,
  });

  const { data: mensajes = [] } = useQuery<Mensaje[]>({
    queryKey: ["mensajes", activo?.id],
    queryFn: async () => (await fetch(`/api/mensajes?con=${activo!.id}`)).json().then((d) => d.mensajes),
    enabled: !!activo,
    refetchInterval: 3000,
  });

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [mensajes]);

  async function enviar() {
    if (!activo || !texto.trim()) return;
    const body = texto.trim();
    setTexto("");
    await fetch("/api/mensajes", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ idDestinatario: activo.id, mensaje: body }),
    });
    qc.invalidateQueries({ queryKey: ["mensajes", activo.id] });
    qc.invalidateQueries({ queryKey: ["conversaciones"] });
    qc.invalidateQueries({ queryKey: ["mensajes-unread"] });
  }

  const listaCompleta: Conversacion[] =
    activo && !conversaciones.some((c) => c.id === activo.id)
      ? [{ id: activo.id, nombre: activo.nombre, imagen: activo.imagen, ultimoMensaje: "", fecha: "", noLeidos: 0 }, ...conversaciones]
      : conversaciones;

  return (
    <div className="mx-auto flex h-[calc(100dvh-4rem)] max-w-6xl">
      {/* lista */}
      <aside className="flex w-full max-w-xs flex-col border-r">
        <div className="bg-app-gradient p-4 font-heading text-lg font-bold text-white">Mensajes</div>
        <div className="flex-1 overflow-y-auto">
          {listaCompleta.length === 0 && (
            <p className="p-4 text-sm text-muted-foreground">Todavía no tenés conversaciones.</p>
          )}
          {listaCompleta.map((c) => (
            <button
              key={c.id}
              onClick={() => setActivo({ id: c.id, nombre: c.nombre, imagen: c.imagen ?? "" })}
              className={cn(
                "flex w-full items-center gap-3 border-b p-3 text-left hover:bg-accent",
                activo?.id === c.id && "bg-accent",
              )}
            >
              <Image
                src={c.imagen || `https://ui-avatars.com/api/?name=${encodeURIComponent(c.nombre)}`}
                alt=""
                width={40}
                height={40}
                className="size-10 rounded-full object-cover"
              />
              <span className="min-w-0 flex-1">
                <span className="flex items-center justify-between">
                  <span className="truncate font-medium">{c.nombre}</span>
                  {c.noLeidos > 0 && (
                    <span className="ml-1 rounded-full bg-red-500 px-1.5 text-[10px] font-bold text-white">
                      {c.noLeidos}
                    </span>
                  )}
                </span>
                <span className="block truncate text-xs text-muted-foreground">{c.ultimoMensaje}</span>
              </span>
            </button>
          ))}
        </div>
      </aside>

      {/* chat */}
      <section className="flex flex-1 flex-col">
        {!activo ? (
          <div className="grid flex-1 place-items-center text-sm text-muted-foreground">
            Seleccioná una conversación
          </div>
        ) : (
          <>
            <div className="flex items-center gap-3 border-b p-3">
              <Image
                src={activo.imagen || `https://ui-avatars.com/api/?name=${encodeURIComponent(activo.nombre)}`}
                alt=""
                width={36}
                height={36}
                className="size-9 rounded-full object-cover"
              />
              <div>
                <p className="font-medium">{activo.nombre}</p>
                <Link href={`/perfil/${activo.id}`} className="text-xs text-brand hover:underline">
                  Ver perfil
                </Link>
              </div>
            </div>
            <div className="flex-1 space-y-2 overflow-y-auto p-4">
              {mensajes.map((m) => (
                <div key={m.id} className={cn("flex", m.esMio ? "justify-end" : "justify-start")}>
                  <div
                    className={cn(
                      "max-w-xs rounded-2xl px-3.5 py-2 text-sm",
                      m.esMio ? "bg-app-gradient text-white" : "border bg-card",
                    )}
                  >
                    <p>{m.mensaje}</p>
                    <p className={cn("mt-1 text-[10px]", m.esMio ? "text-white/70" : "text-muted-foreground")}>
                      {fechaHora(m.fechaEnvio)}
                    </p>
                  </div>
                </div>
              ))}
              <div ref={bottomRef} />
            </div>
            <form
              onSubmit={(e) => {
                e.preventDefault();
                enviar();
              }}
              className="flex gap-2 border-t p-3"
            >
              <input
                value={texto}
                onChange={(e) => setTexto(e.target.value)}
                maxLength={1000}
                placeholder="Escribí un mensaje…"
                className="flex-1 rounded-full border px-4 py-2 text-sm outline-none focus:border-brand"
              />
              <button type="submit" className="grid size-10 place-items-center rounded-full bg-brand text-white hover:bg-brand-dark">
                <Send className="size-4" />
              </button>
            </form>
          </>
        )}
      </section>
    </div>
  );
}
