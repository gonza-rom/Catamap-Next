import type { MetadataRoute } from "next";

const siteName = process.env.NEXT_PUBLIC_SITE_NAME ?? "Catamap";

export default function manifest(): MetadataRoute.Manifest {
  return {
    id: "/",
    name: `${siteName} — Turismo colaborativo de Catamarca`,
    short_name: siteName,
    description:
      "Descubrí atractivos turísticos poco convencionales de Catamarca en un mapa colaborativo y sumá los tuyos.",
    start_url: "/",
    scope: "/",
    display: "standalone",
    orientation: "portrait-primary",
    lang: "es-AR",
    background_color: "#ffffff",
    theme_color: "#e07b39",
    categories: ["travel", "navigation", "lifestyle"],
    icons: [
      {
        src: "/icons/icon-192.png",
        sizes: "192x192",
        type: "image/png",
        purpose: "any",
      },
      {
        src: "/icons/icon-512.png",
        sizes: "512x512",
        type: "image/png",
        purpose: "any",
      },
      {
        src: "/icons/icon-maskable-512.png",
        sizes: "512x512",
        type: "image/png",
        purpose: "maskable",
      },
    ],
  };
}
