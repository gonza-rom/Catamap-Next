import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";

// /perfil/[id] (perfil público) NO requiere sesión — sólo /perfil (el propio).
const PROTECTED_EXACT = ["/perfil"];
const PROTECTED_PREFIX = ["/mensajes", "/sugerir", "/admin"];

export async function updateSession(request: NextRequest) {
  let response = NextResponse.next({ request });

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value));
          response = NextResponse.next({ request });
          cookiesToSet.forEach(({ name, value, options }) =>
            response.cookies.set(name, value, options),
          );
        },
      },
    },
  );

  const {
    data: { user },
  } = await supabase.auth.getUser();

  const path = request.nextUrl.pathname;
  const needsAuth =
    PROTECTED_EXACT.includes(path) || PROTECTED_PREFIX.some((p) => path === p || path.startsWith(p + "/"));

  if (needsAuth && !user) {
    const url = request.nextUrl.clone();
    url.pathname = "/";
    url.searchParams.set("login", "1");
    url.searchParams.set("next", path);
    return NextResponse.redirect(url);
  }

  // El chequeo de rol admin para /admin se hace en app/admin/layout.tsx (necesita DB).
  return response;
}
