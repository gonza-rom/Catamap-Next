# Catamap

Plataforma de turismo colaborativo de Catamarca — migrada desde PHP/MySQL a **Next.js 16 + TypeScript
+ Prisma + Supabase**, con Cloudinary para imágenes y Leaflet para el mapa interactivo.

Repo original (PHP): https://github.com/gonza-rom/Catamap

## Stack

- Next.js 16 (App Router) + React 19 + TypeScript
- Prisma → Supabase Postgres
- Supabase Auth (`@supabase/ssr`)
- Tailwind CSS v4 + shadcn/ui + sonner
- Leaflet + react-leaflet (mapa) + OpenRouteService (ruteo)
- Cloudinary (`next-cloudinary`)

## Desarrollo

```bash
npm install
npm run db:migrate   # crea el esquema en Supabase (usa DIRECT_URL)
npm run db:seed       # importa data/catamap.json (dump del proyecto PHP)
npm run dev
```

- `npm run db:studio` — abre Prisma Studio.
- `npm run build` — build de producción (corre `prisma generate` primero).

## Variables de entorno

Ver `.env.example`. Las claves reales viven en `.env` (no se commitea).

- **Supabase**: URL + anon key (públicas) + service role key (sólo servidor, usada en el seed y en
  `registerAction`/admin).
- **`DATABASE_URL`** (pooler, puerto 6543) para runtime; **`DIRECT_URL`** (puerto 5432) para
  migraciones.
- **Cloudinary**: cloud name + upload preset *unsigned* (`catamap`) para subir imágenes desde el
  cliente (avatar, sugerencias, admin).
- **`ORS_API_KEY`**: key gratuita de [OpenRouteService](https://openrouteservice.org/dev/#/signup)
  para el botón "Ir aquí" del mapa. Sin ella, el ruteo muestra un error pero el resto del mapa
  funciona igual.
- **`SEED_DEFAULT_PASSWORD`**: password que se le asigna a los usuarios importados del dump PHP
  (sus contraseñas bcrypt originales no son migrables a Supabase Auth).

## Datos

`data/catamap.json` es el export JSON de phpMyAdmin del proyecto PHP original (usuarios, categorías,
departamentos, 1419 lugares, comentarios, favoritos, sugerencias, mensajes, seguidores, insignias).
`prisma/seed.ts` lo parsea, crea los usuarios en Supabase Auth (remapeando sus IDs `int` a `uuid`) y
carga todo lo demás. Es idempotente: se puede correr de nuevo y vuelve a dejar la base en el mismo
estado (reutiliza los usuarios de Auth existentes).

## Estructura

```
src/app/(main)/     páginas públicas: home, lugares, lugares/[id], perfil, perfil/[id], mensajes, sugerir
src/app/mapa/        mapa interactivo (full-bleed, sin navbar)
src/app/admin/       panel de administración (guard de rol admin)
src/app/api/         route handlers consumidos por el cliente (mensajes, ruta ORS)
src/components/      UI por dominio (map, lugares, perfil, admin, auth, layout) + shadcn en ui/
src/lib/actions/     server actions (mutaciones)
src/lib/data/        queries de lectura reutilizadas por las páginas
prisma/schema.prisma esquema completo + prisma/seed.ts
```

## Paridad con el proyecto PHP

Implementado: auth (registro/login/logout con Supabase Auth), mapa con capas base, polígonos de
departamentos, filtro por categoría, búsqueda, geolocalización, ruteo, favoritos en mapa,
catálogo de lugares con filtros y paginación, detalle con reseñas/valoración y moderación,
favoritos, sugerir lugar (con mapa click-to-coords y foto), perfil propio (7 tabs), perfil público
con privacidad, seguidores, mensajería con polling, insignias, y panel admin completo (dashboard,
usuarios, lugares, sugerencias, comentarios, categorías, departamentos).

Mejoras respecto del original: sin SQL injection, sin CORS abierto en auth, un solo endpoint de
privacidad y de seguir/dejar de seguir (el PHP tenía 3 y 2 duplicados respectivamente),
`motivo_rechazo`/`fecha_revision` de sugerencias ahora se escriben, editar una reseña siempre la
vuelve a poner en `pendiente`.
