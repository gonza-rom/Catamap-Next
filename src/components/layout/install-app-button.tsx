"use client";

import { useEffect, useState } from "react";
import { Download, Share } from "lucide-react";

type BeforeInstallPromptEvent = Event & {
  prompt: () => Promise<void>;
  userChoice: Promise<{ outcome: "accepted" | "dismissed" }>;
};

/**
 * Botón "Instalar app": dispara el prompt nativo en Chrome/Edge/Android
 * (evento beforeinstallprompt) y muestra instrucciones manuales en iOS,
 * donde Safari no expone ese evento. No se renderiza si la app ya corre
 * instalada (display-mode: standalone) ni en navegadores sin soporte.
 */
export function InstallAppButton({
  className,
  labelClassName,
}: {
  className?: string;
  labelClassName?: string;
}) {
  const [deferredPrompt, setDeferredPrompt] = useState<BeforeInstallPromptEvent | null>(null);
  const [isIOS, setIsIOS] = useState(false);
  const [isStandalone, setIsStandalone] = useState(true);
  const [showIOSHelp, setShowIOSHelp] = useState(false);

  useEffect(() => {
    const standalone =
      window.matchMedia("(display-mode: standalone)").matches ||
      (window.navigator as unknown as { standalone?: boolean }).standalone === true;
    setIsStandalone(standalone);
    setIsIOS(/iphone|ipad|ipod/i.test(window.navigator.userAgent));

    const onBeforeInstall = (e: Event) => {
      e.preventDefault();
      setDeferredPrompt(e as BeforeInstallPromptEvent);
    };
    const onInstalled = () => {
      setDeferredPrompt(null);
      setIsStandalone(true);
    };
    window.addEventListener("beforeinstallprompt", onBeforeInstall);
    window.addEventListener("appinstalled", onInstalled);
    return () => {
      window.removeEventListener("beforeinstallprompt", onBeforeInstall);
      window.removeEventListener("appinstalled", onInstalled);
    };
  }, []);

  if (isStandalone || (!deferredPrompt && !isIOS)) return null;

  async function handleClick() {
    if (deferredPrompt) {
      await deferredPrompt.prompt();
      await deferredPrompt.userChoice;
      setDeferredPrompt(null);
      return;
    }
    setShowIOSHelp((v) => !v);
  }

  return (
    <div className="relative">
      <button
        onClick={handleClick}
        className={
          className ??
          "inline-flex items-center gap-1.5 rounded-full border px-4 py-2 text-sm font-semibold hover:bg-accent"
        }
      >
        <Download className="size-4" /> <span className={labelClassName}>Instalar app</span>
      </button>
      {showIOSHelp && (
        <div className="absolute right-0 top-full z-50 mt-2 w-64 rounded-xl border bg-card p-3 text-sm shadow-lg">
          <p className="font-medium">Instalar en iOS/Android</p>
          <p className="mt-1 text-muted-foreground">
            Tocá <Share className="inline size-3.5 -translate-y-0.5" /> Compartir en Safari y elegí
            “Agregar a inicio”.
          </p>
          <button onClick={() => setShowIOSHelp(false)} className="mt-2 text-xs font-medium text-brand">
            Entendido
          </button>
        </div>
      )}
    </div>
  );
}
