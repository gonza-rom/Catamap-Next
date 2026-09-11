"use client";

import "leaflet/dist/leaflet.css";
import "./map-styles.css";
import { MapContainer, TileLayer, Marker, Circle, Popup } from "react-leaflet";
import { simplePin } from "./icons";

type Props = { lat: number; lng: number; nombre: string };

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
      <Marker position={[lat, lng]} icon={simplePin()}>
        <Popup>{nombre}</Popup>
      </Marker>
    </MapContainer>
  );
}
