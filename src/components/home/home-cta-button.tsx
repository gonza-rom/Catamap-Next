"use client";

import Link from "next/link";
import { useAuthModal } from "@/components/auth/auth-modal";

export function HomeCtaButton({ isAuthenticated }: { isAuthenticated: boolean }) {
  const { open } = useAuthModal();

  if (isAuthenticated) {
    return (
      <Link
        href="/sugerir"
        className="inline-block rounded-full bg-brand px-6 py-3 font-semibold text-white hover:bg-brand-dark"
      >
        Sugerir un lugar
      </Link>
    );
  }

  return (
    <button
      onClick={() => open("register")}
      className="rounded-full bg-brand px-6 py-3 font-semibold text-white hover:bg-brand-dark"
    >
      Registrate gratis
    </button>
  );
}
