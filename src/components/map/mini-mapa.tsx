"use client";

import "leaflet/dist/leaflet.css";
import "./map-styles.css";
import L from "leaflet";
import { MapContainer, TileLayer, Marker, Circle, Popup } from "react-leaflet";

type Props = { lat: number; lng: number; nombre: string };

const pin = L.divIcon({
  className: "cm-mini-pin",
  html: `<span style="font-size:30px;filter:drop-shadow(0 2px 3px rgba(0,0,0,.4))">📍</span>`,
  iconSize: [30, 30],
  iconAnchor: [15, 30],
  popupAnchor: [0, -28],
});

export default function MiniMapa({ lat, lng, nombre }: Props) {
  return (
    <MapContainer
      center={[lat, lng]}
      zoom={14}
      scrollWheelZoom={false}
      dragging={false}
      doubleClickZoom={false}
      zoomControl={false}
      attributionControl={false}
      className="h-64 w-full rounded-xl"
      style={{ cursor: "default" }}
    >
      <TileLayer url="https://tile.openstreetmap.org/{z}/{x}/{y}.png" />
      <Circle center={[lat, lng]} radius={200} pathOptions={{ color: "#e07b39", weight: 1, fillOpacity: 0.08 }} />
      <Marker position={[lat, lng]} icon={pin}>
        <Popup>{nombre}</Popup>
      </Marker>
    </MapContainer>
  );
}
