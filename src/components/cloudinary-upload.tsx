"use client";

import { CldUploadWidget } from "next-cloudinary";
import { ImagePlus, Loader2 } from "lucide-react";
import { useState } from "react";
import { cn } from "@/lib/utils";

type Props = {
  onUploaded: (url: string) => void | Promise<void>;
  label?: string;
  className?: string;
};

/** Botón de subida a Cloudinary (preset unsigned `catamap`). Devuelve la secure_url. */
export function CloudinaryUpload({ onUploaded, label = "Subir imagen", className }: Props) {
  const preset = process.env.NEXT_PUBLIC_CLOUDINARY_UPLOAD_PRESET!;
  const [busy, setBusy] = useState(false);

  return (
    <CldUploadWidget
      uploadPreset={preset}
      options={{ sources: ["local", "camera"], multiple: false, maxFileSize: 5_000_000 }}
      onSuccess={async (result) => {
        const info = result.info;
        if (info && typeof info !== "string" && "secure_url" in info) {
          setBusy(true);
          try {
            await onUploaded(info.secure_url as string);
          } finally {
            setBusy(false);
          }
        }
      }}
    >
      {({ open }) => (
        <button
          type="button"
          onClick={() => open()}
          disabled={busy}
          className={cn(
            "inline-flex items-center gap-2 rounded-full border px-4 py-2 text-sm font-medium hover:bg-accent disabled:opacity-60",
            className,
          )}
        >
          {busy ? <Loader2 className="size-4 animate-spin" /> : <ImagePlus className="size-4" />}
          {label}
        </button>
      )}
    </CldUploadWidget>
  );
}
