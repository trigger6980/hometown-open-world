# Hometown Open World

Open-world driving game built on real **OpenStreetMap** road data. Every player gets their own map — their hometown — for free. No hand-authored miles.

## One-liner

The only game where your hometown is the level.

## Status

Vertical slice in progress. Target: one US city, one drivable vehicle, streaming map tiles around the player.

## Architecture

```
 hometown-open-world/
 ├── data/                 # OSM ingestion & normalization
 │   ├── ingest/           # Overpass API queries, raw PBF handling
 │   ├── normalize/        # Road graph: nodes, edges, lanes, speed limits
 │   └── export/           # Engine-ready tile format (JSON/binary)
 ├── engine/               # Runtime
 │   ├── streaming/        # Chunk loading around player position
 │   ├── traffic/          # NPC vehicle AI, intersection logic
 │   ├── physics/          # Vehicle dynamics
 │   └── world/            # Terrain, buildings, day-night, weather
 ├── game/                 # Player-facing logic
 │   ├── player/           # Input, camera, HUD
 │   └── systems/          # Save, settings, pause
 ├── assets/               # Models, textures, audio (git-lfs)
 ├── tools/                # CLI utilities, tile previewer
 ├── tests/                # Unit + integration
 └── docs/                 # Design docs, pitch, roadmap
```

## Stack

- **Engine:** Godot 4.x (primary). Unreal 5 fallback if physics demands it.
- **Language:** GDScript for gameplay; Rust or C++ for the data pipeline and streaming core.
- **Map data:** OpenStreetMap via Overpass API (live) and Geofabrik PBF extracts (offline).
- **Terrain/satellite:** USGS 3DEP elevation, ESA Sentinel-2 imagery.
- **Procedural fill:** Census + zoning data seeds building/traffic generation for sparse rural tiles.

## Roadmap

1. **Slice 0** — Baton Rouge neighborhood. Load OSM roads, drive one car, stream tiles. No NPCs.
2. **Slice 1** — Traffic AI at a handful of intersections. Basic buildings from OSM footprints.
3. **Slice 2** — Procedural rural fill. Day-night cycle. Weather.
4. **Slice 3** — Second city. Contribution loop: players fix bad data upstream in OSM, game patches itself.
5. **Slice 4** — Pitch-ready build for Steam Next Fest.

## Data sources & licensing

| Source | License | Use |
| --- | --- | --- |
| OpenStreetMap | ODbL | Road graph, POIs, building footprints |
| USGS 3DEP | Public domain | Elevation |
| ESA Sentinel-2 | CC-BY-SA 3.0 | Satellite imagery |
| US Census | Public domain | Demographics, zoning seeds |

OSM attribution required in-game. No Google Street View or licensed imagery.

## Contributing

Issues and PRs welcome. See `docs/CONTRIBUTING.md`.

## License

Game code: MIT. Map data: ODbL (share-alike). See `LICENSE`.
