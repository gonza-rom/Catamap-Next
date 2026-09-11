const fFecha = new Intl.DateTimeFormat("es-AR", { day: "2-digit", month: "2-digit", year: "numeric" });
const fFechaHora = new Intl.DateTimeFormat("es-AR", {
  day: "2-digit",
  month: "2-digit",
  year: "numeric",
  hour: "2-digit",
  minute: "2-digit",
});
const fMes = new Intl.DateTimeFormat("es-AR", { month: "long", year: "numeric" });

export const fecha = (d: Date | string) => fFecha.format(new Date(d));
export const fechaHora = (d: Date | string) => fFechaHora.format(new Date(d));
export const mesAnio = (d: Date | string) => fMes.format(new Date(d));
