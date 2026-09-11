"use client";

import { useRouter } from "next/navigation";
import { logoutAction } from "@/lib/actions/auth";

export function AdminLogoutButton() {
  const router = useRouter();
  return (
    <button
      onClick={async () => {
        await logoutAction();
        router.push("/");
        router.refresh();
      }}
      className="block w-full rounded-md px-3 py-2 text-left hover:bg-white/10"
    >
      Cerrar sesión
    </button>
  );
}
