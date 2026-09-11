const KEY = "catamap:mapa:state";

export type MapState = {
  cats: string[];
  favs: boolean;
  center: [number, number];
  zoom: number;
};

export function loadMapState(): MapState | null {
  try {
    const raw = sessionStorage.getItem(KEY);
    if (!raw) return null;
    return JSON.parse(raw) as MapState;
  } catch {
    return null;
  }
}

export function saveMapState(partial: Partial<MapState>) {
  try {
    const current = loadMapState() ?? { cats: [], favs: false, center: [-28.47, -65.79], zoom: 7 };
    sessionStorage.setItem(KEY, JSON.stringify({ ...current, ...partial }));
  } catch {
    // sessionStorage no disponible (modo privado, etc.) — se ignora.
  }
}
