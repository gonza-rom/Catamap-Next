"use client";

import {
  createContext,
  Suspense,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
} from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { LoginRegisterForm } from "./login-register-form";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog";

type AuthModalCtx = {
  open: (mode?: "login" | "register") => void;
  close: () => void;
};

const Ctx = createContext<AuthModalCtx | null>(null);

export function useAuthModal() {
  const ctx = useContext(Ctx);
  if (!ctx) throw new Error("useAuthModal debe usarse dentro de <AuthModalProvider>");
  return ctx;
}

/** Lee ?login=1 y abre el modal (redirección del middleware). Aislado en Suspense. */
function LoginParamWatcher({ isAuthenticated, onOpen }: { isAuthenticated: boolean; onOpen: () => void }) {
  const params = useSearchParams();
  useEffect(() => {
    if (params.get("login") === "1" && !isAuthenticated) onOpen();
  }, [params, isAuthenticated, onOpen]);
  return null;
}

export function AuthModalProvider({
  children,
  isAuthenticated,
}: {
  children: React.ReactNode;
  isAuthenticated: boolean;
}) {
  const [isOpen, setIsOpen] = useState(false);
  const [mode, setMode] = useState<"login" | "register">("login");
  const router = useRouter();

  const open = useCallback((m: "login" | "register" = "login") => {
    setMode(m);
    setIsOpen(true);
  }, []);
  const close = useCallback(() => setIsOpen(false), []);

  const value = useMemo(() => ({ open, close }), [open, close]);

  return (
    <Ctx.Provider value={value}>
      {children}
      <Suspense fallback={null}>
        <LoginParamWatcher isAuthenticated={isAuthenticated} onOpen={() => open("login")} />
      </Suspense>
      <Dialog open={isOpen} onOpenChange={setIsOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle className="text-center text-xl">
              {mode === "login" ? "Iniciar sesión" : "Crear cuenta"}
            </DialogTitle>
          </DialogHeader>
          <LoginRegisterForm
            mode={mode}
            onModeChange={setMode}
            onSuccess={() => {
              setIsOpen(false);
              router.refresh();
            }}
          />
        </DialogContent>
      </Dialog>
    </Ctx.Provider>
  );
}
