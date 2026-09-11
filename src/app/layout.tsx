import type { Metadata } from "next";
import { Poppins } from "next/font/google";
import "./globals.css";
import { Providers } from "@/components/providers";
import { AuthGate } from "@/components/auth/auth-gate";
import { Toaster } from "@/components/ui/sonner";

const poppins = Poppins({
  subsets: ["latin"],
  variable: "--font-sans",
  weight: ["300", "400", "500", "600", "700", "800"],
  display: "swap",
});

const siteName = process.env.NEXT_PUBLIC_SITE_NAME ?? "Catamap";

export const metadata: Metadata = {
  title: {
    default: `${siteName} — Turismo colaborativo de Catamarca`,
    template: `%s · ${siteName}`,
  },
  description:
    "Plataforma de turismo sostenible y colaborativo para Catamarca. Descubrí atractivos poco convencionales en un mapa interactivo y sumá los tuyos.",
  metadataBase: new URL(process.env.NEXT_PUBLIC_APP_URL ?? "http://localhost:3000"),
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="es" className={`${poppins.variable} h-full antialiased`}>
      <body className="flex min-h-full flex-col bg-background font-sans">
        <Providers>
          <AuthGate>{children}</AuthGate>
        </Providers>
        <Toaster richColors position="top-center" />
      </body>
    </html>
  );
}
