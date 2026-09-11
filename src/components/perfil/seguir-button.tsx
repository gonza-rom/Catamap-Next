"use client";

import { useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { toggleSeguir } from "@/lib/actions/perfil";

export function SeguirButton({ idObjetivo, initial }: { idObjetivo: string; initial: boolean }) {
  const [siguiendo, setSiguiendo] = useState(initial);
  const [pending, start] = useTransition();
  const router = useRouter();

  return (
    <button
      disabled={pending}
      onClick={() =>
        start(async () => {
          const res = await toggleSeguir(idObjetivo);
          if (!res.ok) {
            toast.error(res.error);
            return;
          }
          setSiguiendo(res.siguiendo);
          router.refresh();
        })
      }
      className={
        siguiendo
          ? "rounded-full border border-white/60 px-5 py-2 text-sm font-medium hover:bg-white/10"
          : "rounded-full bg-white px-5 py-2 text-sm font-medium text-brand hover:bg-white/90"
      }
    >
      {siguiendo ? "Siguiendo" : "Seguir"}
    </button>
  );
}
