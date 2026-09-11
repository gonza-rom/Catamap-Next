"use client";

import { useState, useTransition } from "react";
import { Heart } from "lucide-react";
import { toast } from "sonner";
import { useRouter } from "next/navigation";
import { cn } from "@/lib/utils";
import { toggleFavorito } from "@/lib/actions/favoritos";
import { useAuthModal } from "@/components/auth/auth-modal";

type Props = {
  idLugar: number;
  initial: boolean;
  isAuthenticated: boolean;
  variant?: "icon" | "button";
  className?: string;
};

export function FavoritoButton({ idLugar, initial, isAuthenticated, variant = "icon", className }: Props) {
  const [fav, setFav] = useState(initial);
  const [pending, start] = useTransition();
  const { open } = useAuthModal();
  const router = useRouter();

  function handle() {
    if (!isAuthenticated) {
      open("login");
      return;
    }
    start(async () => {
      const res = await toggleFavorito(idLugar);
      if (!res.ok) {
        toast.error(res.error);
        return;
      }
      setFav(res.favorito);
      toast.success(res.favorito ? "Agregado a favoritos" : "Quitado de favoritos");
      router.refresh();
    });
  }

  if (variant === "button") {
    return (
      <button
        onClick={handle}
        disabled={pending}
        className={cn(
          "inline-flex items-center gap-2 rounded-full border px-4 py-2 text-sm font-medium transition",
          fav ? "border-red-200 bg-red-50 text-red-600" : "hover:bg-accent",
          className,
        )}
      >
        <Heart className={cn("size-4", fav && "fill-current")} />
        {fav ? "En favoritos" : "Guardar"}
      </button>
    );
  }

  return (
    <button
      onClick={handle}
      disabled={pending}
      aria-label={fav ? "Quitar de favoritos" : "Agregar a favoritos"}
      className={cn(
        "grid size-9 place-items-center rounded-full bg-white/90 shadow-sm backdrop-blur transition hover:scale-105",
        className,
      )}
    >
      <Heart className={cn("size-4", fav ? "fill-red-500 text-red-500" : "text-neutral-600")} />
    </button>
  );
}
