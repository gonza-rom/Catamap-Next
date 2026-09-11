import L from "leaflet";

/** Marcador con emoji de categoría. */
export function emojiIcon(emoji: string) {
  return L.divIcon({
    className: "cm-emoji-marker",
    html: `<span style="font-size:26px;line-height:1;filter:drop-shadow(0 1px 2px rgba(0,0,0,.35))">${emoji || "📍"}</span>`,
    iconSize: [30, 30],
    iconAnchor: [15, 28],
    popupAnchor: [0, -26],
  });
}

/** Marcador de ubicación del usuario (punto con pulso). */
export function userIcon() {
  return L.divIcon({
    className: "cm-user-marker",
    html: `<span class="cm-user-dot"></span>`,
    iconSize: [22, 22],
    iconAnchor: [11, 11],
  });
}

/** Marcador de favorito (estrella dorada). */
export function favIcon() {
  return L.divIcon({
    className: "cm-fav-marker",
    html: `<span style="font-size:24px;filter:drop-shadow(0 1px 2px rgba(0,0,0,.4))">⭐</span>`,
    iconSize: [28, 28],
    iconAnchor: [14, 26],
    popupAnchor: [0, -24],
  });
}
