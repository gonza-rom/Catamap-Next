import { getAuthUser } from "@/lib/auth";
import { AuthModalProvider } from "./auth-modal";

/** Envuelve la app con el provider del modal de auth, informándole si hay sesión. */
export async function AuthGate({ children }: { children: React.ReactNode }) {
  const user = await getAuthUser();
  return <AuthModalProvider isAuthenticated={!!user}>{children}</AuthModalProvider>;
}
