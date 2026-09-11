"use client";

import dynamic from "next/dynamic";

const MiniMapa = dynamic(() => import("./mini-mapa"), {
  ssr: false,
  loading: () => <div className="h-64 w-full animate-pulse rounded-xl bg-muted" />,
});

export { MiniMapa };
