"use client";

import { useState } from "react";
import { toast } from "sonner";
import { Eye, EyeOff, Loader2, ChevronDown } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { loginAction, registerAction } from "@/lib/actions/auth";
import { loginSchema, registerSchema } from "@/lib/validations/auth";
import { cn } from "@/lib/utils";

const CUENTAS_PRUEBA = [
  { email: "admin@catamap.com", rol: "admin" },
  { email: "m@gmail.com", rol: "usuario" },
  { email: "manuel@gmail.com", rol: "usuario" },
];

type Props = {
  mode: "login" | "register";
  onModeChange: (m: "login" | "register") => void;
  onSuccess: () => void;
};

export function LoginRegisterForm({ mode, onModeChange, onSuccess }: Props) {
  const [loading, setLoading] = useState(false);
  const [showPw, setShowPw] = useState(false);
  const [showPw2, setShowPw2] = useState(false);
  const [showCuentas, setShowCuentas] = useState(false);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const fd = new FormData(e.currentTarget);

    setLoading(true);
    try {
      if (mode === "login") {
        const input = { email: String(fd.get("email")), password: String(fd.get("password")) };
        const parsed = loginSchema.safeParse(input);
        if (!parsed.success) {
          toast.error(parsed.error.issues[0].message);
          return;
        }
        const res = await loginAction(parsed.data);
        if (!res.ok) {
          toast.error(res.error);
          return;
        }
        toast.success("¡Bienvenido de vuelta!");
        onSuccess();
      } else {
        const pw = String(fd.get("password"));
        if (pw !== String(fd.get("password2"))) {
          toast.error("Las contraseñas no coinciden");
          return;
        }
        const input = { nombre: String(fd.get("nombre")), email: String(fd.get("email")), password: pw };
        const parsed = registerSchema.safeParse(input);
        if (!parsed.success) {
          toast.error(parsed.error.issues[0].message);
          return;
        }
        const res = await registerAction(parsed.data);
        if (!res.ok) {
          toast.error(res.error);
          return;
        }
        toast.success("¡Cuenta creada! Ya estás dentro.");
        onSuccess();
      }
    } finally {
      setLoading(false);
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      {mode === "register" && (
        <div className="space-y-1.5">
          <Label htmlFor="nombre">Nombre</Label>
          <Input id="nombre" name="nombre" required minLength={3} autoComplete="name" />
        </div>
      )}

      <div className="space-y-1.5">
        <Label htmlFor="email">Email</Label>
        <Input
          id="email"
          name="email"
          type="email"
          required
          autoComplete="email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
      </div>

      <div className="space-y-1.5">
        <Label htmlFor="password">Contraseña</Label>
        <div className="relative">
          <Input
            id="password"
            name="password"
            type={showPw ? "text" : "password"}
            required
            autoComplete={mode === "login" ? "current-password" : "new-password"}
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          <button
            type="button"
            onClick={() => setShowPw((v) => !v)}
            className="absolute right-2 top-1/2 -translate-y-1/2 text-muted-foreground"
            tabIndex={-1}
          >
            {showPw ? <EyeOff className="size-4" /> : <Eye className="size-4" />}
          </button>
        </div>
        {mode === "register" && (
          <p className="text-xs text-muted-foreground">
            Mínimo 8 caracteres, con mayúscula, minúscula y número.
          </p>
        )}
      </div>

      {mode === "register" && (
        <div className="space-y-1.5">
          <Label htmlFor="password2">Repetir contraseña</Label>
          <div className="relative">
            <Input
              id="password2"
              name="password2"
              type={showPw2 ? "text" : "password"}
              required
              autoComplete="new-password"
            />
            <button
              type="button"
              onClick={() => setShowPw2((v) => !v)}
              className="absolute right-2 top-1/2 -translate-y-1/2 text-muted-foreground"
              tabIndex={-1}
            >
              {showPw2 ? <EyeOff className="size-4" /> : <Eye className="size-4" />}
            </button>
          </div>
        </div>
      )}

      <Button type="submit" className="w-full" disabled={loading}>
        {loading && <Loader2 className="size-4 animate-spin" />}
        {mode === "login" ? "Ingresar" : "Registrarme"}
      </Button>

      {mode === "login" && (
        <div className="rounded-lg border bg-secondary/60 text-xs">
          <button
            type="button"
            onClick={() => setShowCuentas((v) => !v)}
            className="flex w-full items-center justify-between px-3 py-2 font-medium text-secondary-foreground"
          >
            Cuentas de prueba
            <ChevronDown className={cn("size-3.5 transition-transform", showCuentas && "rotate-180")} />
          </button>
          {showCuentas && (
            <div className="space-y-1 px-3 pb-2.5">
              {CUENTAS_PRUEBA.map((c) => (
                <button
                  key={c.email}
                  type="button"
                  onClick={() => {
                    setEmail(c.email);
                    setPassword("Catamap123!");
                  }}
                  className="flex w-full items-center justify-between rounded-md px-2 py-1 text-left hover:bg-accent"
                >
                  <span>{c.email}</span>
                  <span className="text-muted-foreground capitalize">{c.rol}</span>
                </button>
              ))}
              <p className="px-2 pt-1 text-[11px] text-muted-foreground">
                Contraseña para todas: <code>Catamap123!</code> — tocá una para autocompletar.
              </p>
            </div>
          )}
        </div>
      )}

      <p className="text-center text-sm text-muted-foreground">
        {mode === "login" ? (
          <>
            ¿No tenés cuenta?{" "}
            <button type="button" className="text-brand font-medium" onClick={() => onModeChange("register")}>
              Registrate
            </button>
          </>
        ) : (
          <>
            ¿Ya tenés cuenta?{" "}
            <button type="button" className="text-brand font-medium" onClick={() => onModeChange("login")}>
              Iniciá sesión
            </button>
          </>
        )}
      </p>
    </form>
  );
}
