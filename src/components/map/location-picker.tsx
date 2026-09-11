"use client";

import "leaflet/dist/leaflet.css";
import L from "leaflet";
import { MapContainer, TileLayer, Marker, useMapEvents } from "react-leaflet";
import { useState } from "react";

const pin = L.divIcon({
  className: "",
  html: `<span style="font-size:30px;filter:drop-shadow(0 2px 3px rgba(0,0,0,.4))">📍</span>`,
  iconSize: [30, 30],
  iconAnchor: [15, 30],
});

function ClickHandler({ onPick }: { onPick: (lat: number, lng: number) => void }) {
  useMapEvents({
    click(e) {
      onPick(e.latlng.lat, e.latlng.lng);
    },
  });
  return null;
}

export default function LocationPicker({
  value,
  onChange,
}: {
  value: { lat: number; lng: number } | null;
  onChange: (v: { lat: number; lng: number }) => void;
}) {
  const [pos, setPos] = useState(value);

  return (
    <MapContainer center={[-28.47, -65.79]} zoom={7} className="h-72 w-full rounded-xl">
      <TileLayer url="https://tile.openstreetmap.org/{z}/{x}/{y}.png" />
      <ClickHandler
        onPick={(lat, lng) => {
          setPos({ lat, lng });
          onChange({ lat, lng });
        }}
      />
      {pos && <Marker position={[pos.lat, pos.lng]} icon={pin} />}
    </MapContainer>
  );
}
