# Pitch

## The hook

**The only game where your hometown is the level.**

## The problem

Every open-world game costs a fortune because every mile is hand-built. Rockstar spent hundreds of millions and a thousand people on Los Santos. That model doesn't scale to *your* street.

## The solution

OpenStreetMap already mapped America — roads, lanes, speed limits, intersections, building footprints. We don't build the map. We stream it.

## Why now

- OSM coverage of US roads is near-complete in urban and suburban areas
- Godot 4 and open geospatial tooling (Overpass, USGS 3DEP, Sentinel-2) are mature enough for a solo or small-team build
- No publisher has shipped a real-map driving game at this ambition level

## The product

A driving game where the map is your actual town. Start in Baton Rouge. Drive your real streets. Later: any address in America.

## The moat

1. **Cost per mile ≈ zero.** Hand-built worlds cap at what artists can draw. Ours caps at what OSM has digitized.
2. **Personalization is the feature.** Nobody else can offer "your block" out of the box.
3. **Self-improving data.** Players report bad roads → OSM gets fixed → the game patches itself. The community builds the content.

## Market

- Driving/racing genre on Steam: massive, evergreen
- Nostalgia + local pride: players will share "my hometown in the game" clips — organic marketing
- Modding community potential: custom cars, liveries, events per city

## Competition

- *American/Euro Truck Simulator:* real road data, but trucking-only, low visual fidelity, no hometown framing
- *Cities: Skylines / BeamNG:* simulation-first, not playable-hometown
- Gap: a polished, personal, drive-anywhere game. That gap is this project.

## Ask

Vertical slice funding or a publisher conversation after Slice 4 (Steam Next Fest build).

## Risks

- OSM rural sparsity → mitigated by procedural fill seeded on census data
- Tile streaming latency → mitigated by prefetching and binary tile format
- Scope creep → roadmap slices have hard pass criteria; out-of-scope list is binding for v1
