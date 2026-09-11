import { createClient } from "@supabase/supabase-js";

/**
 * Cliente de Supabase con service role. SOLO para uso en servidor
 * (seed, creación de usuarios, operaciones privilegiadas). Nunca exponer al cliente.
 */
export function createAdminClient() {
  return createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.SUPABASE_SERVICE_ROLE_KEY!,
    { auth: { autoRefreshToken: false, persistSession: false } },
  );
}
