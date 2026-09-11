-- CreateEnum
CREATE TYPE "Rol" AS ENUM ('usuario', 'emprendedor', 'admin');

-- CreateEnum
CREATE TYPE "EstadoUsuario" AS ENUM ('activo', 'suspendido', 'inactivo');

-- CreateEnum
CREATE TYPE "EstadoLugar" AS ENUM ('pendiente', 'aprobado', 'rechazado');

-- CreateEnum
CREATE TYPE "EstadoSugerencia" AS ENUM ('pendiente', 'aprobado', 'rechazado');

-- CreateEnum
CREATE TYPE "EstadoComentario" AS ENUM ('pendiente', 'aprobado', 'rechazado');

-- CreateTable
CREATE TABLE "perfiles" (
    "id" UUID NOT NULL,
    "nombre" VARCHAR(100) NOT NULL,
    "rol" "Rol" NOT NULL DEFAULT 'usuario',
    "estado" "EstadoUsuario" NOT NULL DEFAULT 'activo',
    "imagen_perfil" VARCHAR(500),
    "telefono" VARCHAR(30),
    "bio" TEXT,
    "fecha_registro" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ultimo_acceso" TIMESTAMP(3),

    CONSTRAINT "perfiles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categorias" (
    "id_categoria" SERIAL NOT NULL,
    "nombre" VARCHAR(100) NOT NULL,
    "descripcion" TEXT,
    "icono" VARCHAR(16) NOT NULL,

    CONSTRAINT "categorias_pkey" PRIMARY KEY ("id_categoria")
);

-- CreateTable
CREATE TABLE "departamentos" (
    "id" SERIAL NOT NULL,
    "nombre" VARCHAR(60) NOT NULL,

    CONSTRAINT "departamentos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lugares_turisticos" (
    "id" SERIAL NOT NULL,
    "nombre" VARCHAR(150) NOT NULL,
    "descripcion" TEXT,
    "direccion" VARCHAR(200),
    "lat" DOUBLE PRECISION,
    "lng" DOUBLE PRECISION,
    "imagen" VARCHAR(500),
    "id_categoria" INTEGER,
    "id_departamento" INTEGER,
    "estado" "EstadoLugar" NOT NULL DEFAULT 'aprobado',
    "id_sugerencia" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "lugares_turisticos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "lugares_sugeridos" (
    "id" SERIAL NOT NULL,
    "id_usuario" UUID NOT NULL,
    "nombre" VARCHAR(255) NOT NULL,
    "descripcion" TEXT,
    "direccion" VARCHAR(255),
    "lat" DOUBLE PRECISION NOT NULL,
    "lng" DOUBLE PRECISION NOT NULL,
    "id_categoria" INTEGER,
    "id_departamento" INTEGER,
    "imagen" VARCHAR(500),
    "estado" "EstadoSugerencia" NOT NULL DEFAULT 'pendiente',
    "motivo_rechazo" TEXT,
    "fecha_sugerido" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_revision" TIMESTAMP(3),
    "revisado_por" UUID,

    CONSTRAINT "lugares_sugeridos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "comentarios" (
    "id" SERIAL NOT NULL,
    "id_lugar" INTEGER NOT NULL,
    "id_usuario" UUID NOT NULL,
    "calificacion" SMALLINT NOT NULL,
    "comentario" TEXT NOT NULL,
    "estado" "EstadoComentario" NOT NULL DEFAULT 'pendiente',
    "fecha_creacion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "fecha_modificacion" TIMESTAMP(3),

    CONSTRAINT "comentarios_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "favoritos" (
    "id" SERIAL NOT NULL,
    "id_usuario" UUID NOT NULL,
    "id_lugar" INTEGER NOT NULL,
    "fecha_agregado" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "favoritos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "seguidores" (
    "id" SERIAL NOT NULL,
    "id_seguidor" UUID NOT NULL,
    "id_seguido" UUID NOT NULL,
    "fecha_inicio" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "seguidores_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "mensajes" (
    "id" SERIAL NOT NULL,
    "id_remitente" UUID NOT NULL,
    "id_destinatario" UUID NOT NULL,
    "mensaje" TEXT NOT NULL,
    "leido" BOOLEAN NOT NULL DEFAULT false,
    "fecha_envio" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "mensajes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "insignias" (
    "id" SERIAL NOT NULL,
    "nombre" VARCHAR(100) NOT NULL,
    "descripcion" TEXT,
    "icono" VARCHAR(100),
    "criterio" VARCHAR(255),
    "puntos_requeridos" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "insignias_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "usuarios_insignias" (
    "id_usuario" UUID NOT NULL,
    "id_insignia" INTEGER NOT NULL,
    "fecha_obtencion" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "usuarios_insignias_pkey" PRIMARY KEY ("id_usuario","id_insignia")
);

-- CreateTable
CREATE TABLE "configuracion_privacidad" (
    "id" SERIAL NOT NULL,
    "id_usuario" UUID NOT NULL,
    "perfil_publico" BOOLEAN NOT NULL DEFAULT true,
    "favoritos_publicos" BOOLEAN NOT NULL DEFAULT true,
    "comentarios_publicos" BOOLEAN NOT NULL DEFAULT true,
    "mostrar_estadisticas" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "configuracion_privacidad_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "departamentos_nombre_key" ON "departamentos"("nombre");

-- CreateIndex
CREATE UNIQUE INDEX "lugares_turisticos_id_sugerencia_key" ON "lugares_turisticos"("id_sugerencia");

-- CreateIndex
CREATE INDEX "lugares_turisticos_id_categoria_idx" ON "lugares_turisticos"("id_categoria");

-- CreateIndex
CREATE INDEX "lugares_turisticos_id_departamento_idx" ON "lugares_turisticos"("id_departamento");

-- CreateIndex
CREATE INDEX "lugares_turisticos_estado_idx" ON "lugares_turisticos"("estado");

-- CreateIndex
CREATE INDEX "lugares_sugeridos_id_usuario_idx" ON "lugares_sugeridos"("id_usuario");

-- CreateIndex
CREATE INDEX "lugares_sugeridos_estado_idx" ON "lugares_sugeridos"("estado");

-- CreateIndex
CREATE INDEX "comentarios_id_lugar_idx" ON "comentarios"("id_lugar");

-- CreateIndex
CREATE INDEX "comentarios_estado_idx" ON "comentarios"("estado");

-- CreateIndex
CREATE UNIQUE INDEX "comentarios_id_usuario_id_lugar_key" ON "comentarios"("id_usuario", "id_lugar");

-- CreateIndex
CREATE INDEX "favoritos_id_usuario_idx" ON "favoritos"("id_usuario");

-- CreateIndex
CREATE INDEX "favoritos_id_lugar_idx" ON "favoritos"("id_lugar");

-- CreateIndex
CREATE UNIQUE INDEX "favoritos_id_usuario_id_lugar_key" ON "favoritos"("id_usuario", "id_lugar");

-- CreateIndex
CREATE INDEX "seguidores_id_seguidor_idx" ON "seguidores"("id_seguidor");

-- CreateIndex
CREATE INDEX "seguidores_id_seguido_idx" ON "seguidores"("id_seguido");

-- CreateIndex
CREATE UNIQUE INDEX "seguidores_id_seguidor_id_seguido_key" ON "seguidores"("id_seguidor", "id_seguido");

-- CreateIndex
CREATE INDEX "mensajes_id_remitente_idx" ON "mensajes"("id_remitente");

-- CreateIndex
CREATE INDEX "mensajes_id_destinatario_idx" ON "mensajes"("id_destinatario");

-- CreateIndex
CREATE INDEX "mensajes_leido_idx" ON "mensajes"("leido");

-- CreateIndex
CREATE INDEX "usuarios_insignias_id_insignia_idx" ON "usuarios_insignias"("id_insignia");

-- CreateIndex
CREATE UNIQUE INDEX "configuracion_privacidad_id_usuario_key" ON "configuracion_privacidad"("id_usuario");

-- AddForeignKey
ALTER TABLE "lugares_turisticos" ADD CONSTRAINT "lugares_turisticos_id_categoria_fkey" FOREIGN KEY ("id_categoria") REFERENCES "categorias"("id_categoria") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lugares_turisticos" ADD CONSTRAINT "lugares_turisticos_id_departamento_fkey" FOREIGN KEY ("id_departamento") REFERENCES "departamentos"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lugares_turisticos" ADD CONSTRAINT "lugares_turisticos_id_sugerencia_fkey" FOREIGN KEY ("id_sugerencia") REFERENCES "lugares_sugeridos"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lugares_sugeridos" ADD CONSTRAINT "lugares_sugeridos_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "perfiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lugares_sugeridos" ADD CONSTRAINT "lugares_sugeridos_revisado_por_fkey" FOREIGN KEY ("revisado_por") REFERENCES "perfiles"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lugares_sugeridos" ADD CONSTRAINT "lugares_sugeridos_id_categoria_fkey" FOREIGN KEY ("id_categoria") REFERENCES "categorias"("id_categoria") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "lugares_sugeridos" ADD CONSTRAINT "lugares_sugeridos_id_departamento_fkey" FOREIGN KEY ("id_departamento") REFERENCES "departamentos"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comentarios" ADD CONSTRAINT "comentarios_id_lugar_fkey" FOREIGN KEY ("id_lugar") REFERENCES "lugares_turisticos"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comentarios" ADD CONSTRAINT "comentarios_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "perfiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "favoritos" ADD CONSTRAINT "favoritos_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "perfiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "favoritos" ADD CONSTRAINT "favoritos_id_lugar_fkey" FOREIGN KEY ("id_lugar") REFERENCES "lugares_turisticos"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "seguidores" ADD CONSTRAINT "seguidores_id_seguidor_fkey" FOREIGN KEY ("id_seguidor") REFERENCES "perfiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "seguidores" ADD CONSTRAINT "seguidores_id_seguido_fkey" FOREIGN KEY ("id_seguido") REFERENCES "perfiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mensajes" ADD CONSTRAINT "mensajes_id_remitente_fkey" FOREIGN KEY ("id_remitente") REFERENCES "perfiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "mensajes" ADD CONSTRAINT "mensajes_id_destinatario_fkey" FOREIGN KEY ("id_destinatario") REFERENCES "perfiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "usuarios_insignias" ADD CONSTRAINT "usuarios_insignias_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "perfiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "usuarios_insignias" ADD CONSTRAINT "usuarios_insignias_id_insignia_fkey" FOREIGN KEY ("id_insignia") REFERENCES "insignias"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "configuracion_privacidad" ADD CONSTRAINT "configuracion_privacidad_id_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "perfiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;
