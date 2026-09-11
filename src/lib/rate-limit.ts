import { headers } from "next/headers";

type Bucket = { count: number; resetAt: number };

/**
 * Limitador simple en memoria, por proceso del servidor. No es distribuido: en un
 * despliegue con varias instancias serverless da protección parcial, no una garantía
 * dura. Está pensado para frenar scripts que golpean login/registro en loop, NO para
 * limitar el uso normal — los límites están calibrados generosos a propósito (ej. un
 * salón entero registrándose desde el mismo Wi-Fi/IP durante una presentación).
 */
const buckets = new Map<string, Bucket>();

async function getClientIp(): Promise<string> {
  const h = await headers();
  const fwd = h.get("x-forwarded-for");
  if (fwd) return fwd.split(",")[0].trim();
  return h.get("x-real-ip") || "unknown";
}

function cleanup(now: number) {
  for (const [key, bucket] of buckets) {
    if (bucket.resetAt < now) buckets.delete(key);
  }
}

export type RateLimitResult = { ok: true } | { ok: false; retryAfterSec: number };

/** `limit` intentos cada `windowMs` por IP + acción. */
export async function rateLimit(action: string, limit: number, windowMs: number): Promise<RateLimitResult> {
  const ip = await getClientIp();
  const key = `${action}:${ip}`;
  const now = Date.now();

  if (Math.random() < 0.02) cleanup(now); // housekeeping ocasional, no en cada request

  const bucket = buckets.get(key);
  if (!bucket || bucket.resetAt < now) {
    buckets.set(key, { count: 1, resetAt: now + windowMs });
    return { ok: true };
  }
  if (bucket.count >= limit) {
    return { ok: false, retryAfterSec: Math.max(1, Math.ceil((bucket.resetAt - now) / 1000)) };
  }
  bucket.count += 1;
  return { ok: true };
}
