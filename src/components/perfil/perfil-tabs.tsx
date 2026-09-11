"use client";

import { useState, useTransition } from "react";
import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { toast } from "sonner";
import { Check, Copy, Trash2 } from "lucide-react";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { lugarImg, avatarImg } from "@/lib/images";
import { fecha } from "@/lib/format";
import { Estrellas } from "@/components/lugares/estrellas";
import { SugerirLugarForm } from "@/components/lugares/sugerir-lugar-form";
import { CloudinaryUpload } from "@/components/cloudinary-upload";
import { toggleFavorito } from "@/lib/actions/favoritos";
import { eliminarComentario } from "@/lib/actions/comentarios";
import { actualizarPerfil, actualizarAvatar, cambiarPassword, guardarPrivacidad, toggleSeguir } from "@/lib/actions/perfil";

type Opt = { id: number; nombre: string };
type Fav = { idLugar: number; nombre: string; imagen: string | null; categoria: string | null; departamento: string | null };
type Resena = { id: number; lugarId: number; lugarNombre: string; calificacion: number; comentario: string; estado: string; fecha: string };
type Sug = { id: number; nombre: string; descripcion: string | null; imagen: string | null; estado: string; motivoRechazo: string | null; departamento: string | null; fecha: string };
type UserLite = { id: string; nombre: string; imagen: string | null };

const estadoBadge: Record<string, string> = {
  aprobado: "bg-green-100 text-green-700",
  pendiente: "bg-amber-100 text-amber-700",
  rechazado: "bg-red-100 text-red-700",
};

export function PerfilTabs(props: {
  userId: string;
  email: string;
  perfil: { nombre: string; telefono: string | null; bio: string | null };
  privacidad: { perfilPublico: boolean; favoritosPublicos: boolean; comentariosPublicos: boolean; mostrarEstadisticas: boolean };
  categorias: Opt[];
  departamentos: Opt[];
  favoritos: Fav[];
  resenas: Resena[];
  sugerencias: Sug[];
  seguidores: UserLite[];
  siguiendo: UserLite[];
}) {
  const router = useRouter();

  return (
    <Tabs defaultValue="info" className="mt-6">
      <TabsList className="flex-wrap">
        <TabsTrigger value="info">Mi información</TabsTrigger>
        <TabsTrigger value="favoritos">Favoritos ({props.favoritos.length})</TabsTrigger>
        <TabsTrigger value="resenas">Reseñas ({props.resenas.length})</TabsTrigger>
        <TabsTrigger value="sugerencias">Sugerencias ({props.sugerencias.length})</TabsTrigger>
        <TabsTrigger value="sugerir">Sugerir lugar</TabsTrigger>
        <TabsTrigger value="social">Social</TabsTrigger>
        <TabsTrigger value="privacidad">Privacidad</TabsTrigger>
      </TabsList>

      {/* INFO */}
      <TabsContent value="info" className="mt-4">
        <InfoTab {...props} />
      </TabsContent>

      {/* FAVORITOS */}
      <TabsContent value="favoritos" className="mt-4">
        {props.favoritos.length === 0 ? (
          <Empty>Todavía no guardaste favoritos.</Empty>
        ) : (
          <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {props.favoritos.map((f) => (
              <div key={f.idLugar} className="overflow-hidden rounded-xl border">
                <Link href={`/lugares/${f.idLugar}`} className="relative block aspect-video">
                  <Image src={lugarImg(f.imagen)} alt={f.nombre} fill className="object-cover" />
                </Link>
                <div className="space-y-1 p-3">
                  <p className="text-xs text-muted-foreground">
                    {f.categoria} · {f.departamento}
                  </p>
                  <p className="font-medium leading-tight">{f.nombre}</p>
                  <div className="flex gap-2 pt-1">
                    <Link href={`/mapa?lugar=${f.idLugar}`} className="text-xs text-brand hover:underline">
                      Ver en mapa
                    </Link>
                    <button
                      onClick={async () => {
                        await toggleFavorito(f.idLugar);
                        toast.success("Quitado de favoritos");
                        router.refresh();
                      }}
                      className="text-xs text-red-500 hover:underline"
                    >
                      Quitar
                    </button>
                  </div>
                </div>
              </div>
            ))}
          </div>
        )}
      </TabsContent>

      {/* RESEÑAS */}
      <TabsContent value="resenas" className="mt-4 space-y-3">
        {props.resenas.length === 0 ? (
          <Empty>No dejaste reseñas todavía.</Empty>
        ) : (
          props.resenas.map((r) => (
            <div key={r.id} className="rounded-xl border p-4">
              <div className="flex flex-wrap items-center gap-2">
                <Link href={`/lugares/${r.lugarId}`} className="font-medium hover:text-brand">
                  {r.lugarNombre}
                </Link>
                <Estrellas value={r.calificacion} size={14} />
                <span className={`rounded-full px-2 py-0.5 text-xs capitalize ${estadoBadge[r.estado]}`}>
                  {r.estado}
                </span>
                <span className="text-xs text-muted-foreground">{fecha(r.fecha)}</span>
                <button
                  onClick={async () => {
                    if (!confirm("¿Eliminar esta reseña?")) return;
                    const res = await eliminarComentario(r.id);
                    if (res.ok) {
                      toast.success("Reseña eliminada");
                      router.refresh();
                    } else toast.error(res.error!);
                  }}
                  className="ml-auto text-muted-foreground hover:text-red-500"
                >
                  <Trash2 className="size-4" />
                </button>
              </div>
              <p className="mt-1 text-sm text-foreground/90">{r.comentario}</p>
            </div>
          ))
        )}
      </TabsContent>

      {/* SUGERENCIAS */}
      <TabsContent value="sugerencias" className="mt-4 space-y-3">
        {props.sugerencias.length === 0 ? (
          <Empty>No sugeriste lugares todavía.</Empty>
        ) : (
          props.sugerencias.map((s) => (
            <div key={s.id} className="flex gap-3 rounded-xl border p-4">
              {s.imagen && (
                <Image src={s.imagen} alt="" width={80} height={80} className="size-20 rounded-lg object-cover" />
              )}
              <div className="flex-1">
                <div className="flex flex-wrap items-center gap-2">
                  <p className="font-medium">{s.nombre}</p>
                  <span className={`rounded-full px-2 py-0.5 text-xs capitalize ${estadoBadge[s.estado]}`}>
                    {s.estado}
                  </span>
                  <span className="text-xs text-muted-foreground">{fecha(s.fecha)}</span>
                </div>
                <p className="text-xs text-muted-foreground">{s.departamento}</p>
                {s.descripcion && <p className="mt-1 line-clamp-2 text-sm">{s.descripcion}</p>}
                {s.estado === "rechazado" && s.motivoRechazo && (
                  <p className="mt-1 rounded bg-red-50 p-2 text-xs text-red-700">Motivo: {s.motivoRechazo}</p>
                )}
              </div>
            </div>
          ))
        )}
      </TabsContent>

      {/* SUGERIR */}
      <TabsContent value="sugerir" className="mt-4">
        <div className="rounded-xl border p-5">
          <SugerirLugarForm categorias={props.categorias} departamentos={props.departamentos} />
        </div>
      </TabsContent>

      {/* SOCIAL */}
      <TabsContent value="social" className="mt-4 grid gap-6 md:grid-cols-2">
        <UserList title={`Mis seguidores (${props.seguidores.length})`} users={props.seguidores} />
        <UserList title={`Siguiendo (${props.siguiendo.length})`} users={props.siguiendo} onUnfollow={props.userId} />
      </TabsContent>

      {/* PRIVACIDAD */}
      <TabsContent value="privacidad" className="mt-4">
        <PrivacidadTab userId={props.userId} initial={props.privacidad} />
      </TabsContent>
    </Tabs>
  );
}

function Empty({ children }: { children: React.ReactNode }) {
  return (
    <div className="rounded-xl border border-dashed p-10 text-center text-sm text-muted-foreground">
      {children}
    </div>
  );
}

function UserList({ title, users }: { title: string; users: UserLite[]; onUnfollow?: string }) {
  const router = useRouter();
  return (
    <div>
      <h3 className="mb-2 font-semibold">{title}</h3>
      {users.length === 0 ? (
        <p className="text-sm text-muted-foreground">Nadie por acá todavía.</p>
      ) : (
        <ul className="space-y-2">
          {users.map((u) => (
            <li key={u.id} className="flex items-center gap-3 rounded-lg border p-2">
              <Image src={avatarImg(u.imagen, u.nombre)} alt="" width={36} height={36} className="size-9 rounded-full object-cover" />
              <Link href={`/perfil/${u.id}`} className="flex-1 text-sm font-medium hover:text-brand">
                {u.nombre}
              </Link>
              <button
                onClick={async () => {
                  await toggleSeguir(u.id);
                  router.refresh();
                }}
                className="text-xs text-muted-foreground hover:text-foreground"
              >
                Seguir / dejar
              </button>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}

function InfoTab({ userId, email, perfil }: { userId: string; email: string; perfil: { nombre: string; telefono: string | null; bio: string | null } }) {
  const router = useRouter();
  const [pending, start] = useTransition();
  const [nombre, setNombre] = useState(perfil.nombre);
  const [telefono, setTelefono] = useState(perfil.telefono ?? "");
  const [bio, setBio] = useState(perfil.bio ?? "");
  const [pwActual, setPwActual] = useState("");
  const [pwNueva, setPwNueva] = useState("");

  return (
    <div className="grid gap-6 md:grid-cols-2">
      <div className="space-y-4 rounded-xl border p-5">
        <h3 className="font-semibold">Datos personales</h3>
        <div className="space-y-1.5">
          <Label>Nombre</Label>
          <Input value={nombre} onChange={(e) => setNombre(e.target.value)} />
        </div>
        <div className="space-y-1.5">
          <Label>Email</Label>
          <Input value={email} disabled />
        </div>
        <div className="space-y-1.5">
          <Label>Teléfono</Label>
          <Input value={telefono} onChange={(e) => setTelefono(e.target.value)} />
        </div>
        <div className="space-y-1.5">
          <Label>Bio</Label>
          <Input value={bio} onChange={(e) => setBio(e.target.value)} maxLength={500} />
        </div>
        <button
          disabled={pending}
          onClick={() =>
            start(async () => {
              const res = await actualizarPerfil({ nombre, telefono, bio });
              if (res.ok) {
                toast.success("Perfil actualizado");
                router.refresh();
              } else toast.error(res.error);
            })
          }
          className="rounded-full bg-brand px-5 py-2 text-sm font-medium text-white hover:bg-brand-dark disabled:opacity-60"
        >
          Guardar cambios
        </button>
      </div>

      <div className="space-y-4 rounded-xl border p-5">
        <h3 className="font-semibold">Foto de perfil</h3>
        <CloudinaryUpload
          label="Cambiar avatar"
          onUploaded={async (url) => {
            const res = await actualizarAvatar(url);
            if (res.ok) {
              toast.success("Avatar actualizado");
              router.refresh();
            } else toast.error(res.error);
          }}
        />

        <h3 className="pt-4 font-semibold">Cambiar contraseña</h3>
        <Input type="password" placeholder="Contraseña actual" value={pwActual} onChange={(e) => setPwActual(e.target.value)} />
        <Input type="password" placeholder="Nueva contraseña" value={pwNueva} onChange={(e) => setPwNueva(e.target.value)} />
        <button
          onClick={() =>
            start(async () => {
              const res = await cambiarPassword({ actual: pwActual, nueva: pwNueva });
              if (res.ok) {
                toast.success("Contraseña actualizada");
                setPwActual("");
                setPwNueva("");
              } else toast.error(res.error);
            })
          }
          className="rounded-full border px-5 py-2 text-sm font-medium hover:bg-accent"
        >
          Actualizar contraseña
        </button>
      </div>
    </div>
  );
}

function PrivacidadTab({ userId, initial }: { userId: string; initial: PerfilTabsProps["privacidad"] }) {
  const router = useRouter();
  const [v, setV] = useState(initial);
  const [pending, start] = useTransition();
  const [copied, setCopied] = useState(false);
  const url = typeof window !== "undefined" ? `${window.location.origin}/perfil/${userId}` : "";

  const rows: [keyof typeof v, string][] = [
    ["perfilPublico", "Perfil público"],
    ["favoritosPublicos", "Mostrar mis favoritos"],
    ["comentariosPublicos", "Mostrar mis comentarios"],
    ["mostrarEstadisticas", "Mostrar mis estadísticas"],
  ];

  return (
    <div className="max-w-lg space-y-4 rounded-xl border p-5">
      {rows.map(([key, label]) => (
        <label key={key} className="flex items-center justify-between">
          <span className="text-sm">{label}</span>
          <Switch checked={v[key]} onCheckedChange={(c) => setV((s) => ({ ...s, [key]: c }))} />
        </label>
      ))}
      <button
        disabled={pending}
        onClick={() =>
          start(async () => {
            const res = await guardarPrivacidad(v);
            if (res.ok) {
              toast.success("Preferencias guardadas");
              router.refresh();
            } else toast.error(res.error);
          })
        }
        className="rounded-full bg-brand px-5 py-2 text-sm font-medium text-white hover:bg-brand-dark disabled:opacity-60"
      >
        Guardar
      </button>

      <div className="pt-2">
        <Label className="text-xs">Tu perfil público</Label>
        <div className="mt-1 flex gap-2">
          <Input value={url} readOnly className="text-xs" />
          <button
            onClick={() => {
              navigator.clipboard.writeText(url);
              setCopied(true);
              setTimeout(() => setCopied(false), 1500);
            }}
            className="grid size-9 shrink-0 place-items-center rounded-md border hover:bg-accent"
          >
            {copied ? <Check className="size-4" /> : <Copy className="size-4" />}
          </button>
        </div>
      </div>
    </div>
  );
}

type PerfilTabsProps = Parameters<typeof PerfilTabs>[0];
