"use client";

import { useState } from "react";
import { toast } from "sonner";
import { Eye, EyeOff, Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { loginAction, registerAction } from "@/lib/actions/auth";
import { loginSchema, registerSchema } from "@/lib/validations/auth";

function useCaptcha() {
  const [a, setA] = useState(() => 1 + Math.floor(Math.random() * 9));
  const [b, setB] = useState(() => 1 + Math.floor(Math.random() * 9));
  const regenerate = () => {
    setA(1 + Math.floor(Math.random() * 9));
    setB(1 + Math.floor(Math.random() * 9));
  };
  return { question: `¿Cuánto es ${a} + ${b}?`, answer: a + b, regenerate };
}

type Props = {
  mode: "login" | "register";
  onModeChange: (m: "login" | "register") => void;
  onSuccess: () => void;
};

export function LoginRegisterForm({ mode, onModeChange, onSuccess }: Props) {
  const [loading, setLoading] = useState(false);
  const [showPw, setShowPw] = useState(false);
  const [showPw2, setShowPw2] = useState(false);
  const captcha = useCaptcha();

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    const fd = new FormData(e.currentTarget);
    const captchaValue = Number(fd.get("captcha"));
    if (captchaValue !== captcha.answer) {
      toast.error("Respuesta del captcha incorrecta");
      captcha.regenerate();
      return;
    }

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
          captcha.regenerate();
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
          captcha.regenerate();
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
        <Input id="email" name="email" type="email" required autoComplete="email" />
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

      <div className="space-y-1.5">
        <Label htmlFor="captcha">{captcha.question}</Label>
        <Input id="captcha" name="captcha" type="number" required inputMode="numeric" />
      </div>

      <Button type="submit" className="w-full" disabled={loading}>
        {loading && <Loader2 className="size-4 animate-spin" />}
        {mode === "login" ? "Ingresar" : "Registrarme"}
      </Button>

      <div className="relative py-1 text-center text-xs text-muted-foreground">
        <span className="relative z-10 bg-background px-2">o continuá con</span>
        <span className="absolute inset-x-0 top-1/2 h-px bg-border" />
      </div>
      <div className="grid grid-cols-2 gap-2">
        {["Google", "Facebook"].map((p) => (
          <Button key={p} type="button" variant="outline" disabled className="relative">
            {p}
            <span className="absolute -top-2 -right-1 rounded-full bg-muted px-1.5 py-0.5 text-[10px]">
              Próximamente
            </span>
          </Button>
        ))}
      </div>

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
