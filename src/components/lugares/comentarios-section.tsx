"use client";

import { useState, useTransition } from "react";
import Image from "next/image";
import Link from "next/link";
import { Star } from "lucide-react";
import { toast } from "sonner";
import { useRouter } from "next/navigation";
import { cn } from "@/lib/utils";
import { avatarImg } from "@/lib/images";
import { Estrellas } from "./estrellas";
import { Textarea } from "@/components/ui/textarea";
import { guardarComentario } from "@/lib/actions/comentarios";
import { useAuthModal } from "@/components/auth/auth-modal";

export type ComentarioItem = {
  id: number;
  usuarioId: string;
  usuarioNombre: string;
  usuarioImagen: string | null;
  calificacion: number;
  comentario: string;
  fecha: string;
};

type Props = {
  idLugar: number;
  comentarios: ComentarioItem[];
  promedio: number;
  total: number;
  isAuthenticated: boolean;
  miEstado: "pendiente" | "aprobado" | "rechazado" | null;
  miComentario: { calificacion: number; comentario: string } | null;
};

export function ComentariosSection({
  idLugar,
  comentarios,
  promedio,
  total,
  isAuthenticated,
  miEstado,
  miComentario,
}: Props) {
  const router = useRouter();
  const { open } = useAuthModal();
  const [rating, setRating] = useState(miComentario?.calificacion ?? 0);
  const [hover, setHover] = useState(0);
  const [texto, setTexto] = useState(miComentario?.comentario ?? "");
  const [pending, start] = useTransition();

  function submit(e: React.FormEvent) {
    e.preventDefault();
    if (rating < 1) return toast.error("Elegí una calificación");
    if (texto.trim().length < 10) return toast.error("El comentario debe tener al menos 10 caracteres");
    start(async () => {
      const res = await guardarComentario({ idLugar, calificacion: rating, comentario: texto.trim() });
      if (!res.ok) {
        toast.error(res.error);
        return;
      }
      toast.success("Tu opinión quedó pendiente de aprobación");
      router.refresh();
    });
  }

  return (
    <section id="opiniones" className="space-y-6">
      <div className="flex items-center gap-4">
        <h2 className="font-heading text-2xl font-bold">Opiniones ({total})</h2>
        {total > 0 && (
          <div className="flex items-center gap-2">
            <span className="text-xl font-bold">{promedio.toFixed(1)}</span>
            <Estrellas value={promedio} />
          </div>
        )}
      </div>

      {/* Form */}
      {isAuthenticated ? (
        <form onSubmit={submit} className="space-y-3 rounded-xl border bg-card p-4">
          <p className="text-sm font-medium">
            {miEstado === "pendiente"
              ? "Tu opinión está pendiente de aprobación. Podés editarla."
              : miComentario
                ? "Editá tu opinión"
                : "Dejá tu opinión"}
          </p>
          <div className="flex gap-1">
            {[1, 2, 3, 4, 5].map((i) => (
              <button
                key={i}
                type="button"
                onMouseEnter={() => setHover(i)}
                onMouseLeave={() => setHover(0)}
                onClick={() => setRating(i)}
                aria-label={`${i} estrellas`}
              >
                <Star
                  className={cn(
                    "size-7 transition",
                    (hover || rating) >= i
                      ? "fill-[var(--star)] text-[var(--star)]"
                      : "fill-muted text-muted",
                  )}
                />
              </button>
            ))}
          </div>
          <Textarea
            value={texto}
            onChange={(e) => setTexto(e.target.value)}
            placeholder="Contá tu experiencia (mínimo 10 caracteres)…"
            rows={3}
            maxLength={1000}
          />
          <button
            type="submit"
            disabled={pending}
            className="rounded-full bg-brand px-5 py-2 text-sm font-medium text-white hover:bg-brand-dark disabled:opacity-60"
          >
            {miComentario ? "Actualizar opinión" : "Publicar opinión"}
          </button>
        </form>
      ) : (
        <div className="rounded-xl border bg-secondary p-4 text-sm">
          <button onClick={() => open("login")} className="font-medium text-brand">
            Iniciá sesión
          </button>{" "}
          para dejar tu opinión.
        </div>
      )}

      {/* Lista */}
      <div className="space-y-4">
        {comentarios.length === 0 && (
          <p className="text-sm text-muted-foreground">Todavía no hay opiniones aprobadas.</p>
        )}
        {comentarios.map((c) => (
          <article key={c.id} className="flex gap-3 rounded-xl border p-4">
            <Image
              src={avatarImg(c.usuarioImagen, c.usuarioNombre)}
              alt={c.usuarioNombre}
              width={40}
              height={40}
              className="size-10 rounded-full object-cover"
            />
            <div className="flex-1">
              <div className="flex flex-wrap items-center gap-2">
                <Link href={`/perfil/${c.usuarioId}`} className="font-medium hover:text-brand">
                  {c.usuarioNombre}
                </Link>
                <Estrellas value={c.calificacion} size={14} />
                <span className="text-xs text-muted-foreground">{c.fecha}</span>
              </div>
              <p className="mt-1 text-sm text-foreground/90">{c.comentario}</p>
            </div>
          </article>
        ))}
      </div>
    </section>
  );
}
