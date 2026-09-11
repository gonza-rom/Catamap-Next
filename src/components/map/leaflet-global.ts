import L from "leaflet";

// leaflet.markercluster es un plugin UMD viejo que espera encontrar `window.L`
// en vez de importar el módulo. Lo exponemos antes de cargarlo.
if (typeof window !== "undefined") {
  (window as unknown as { L: typeof L }).L = L;
}

export default L;
