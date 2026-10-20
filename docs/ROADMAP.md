# Roadmap

## Slice 0 — Proof of Concept (target: 4 weeks)

- [ ] Overpass query pulls all `highway=*` ways inside a Baton Rouge bounding box
- [ ] Normalize into a node-edge graph with lane count and speed limit attributes
- [ ] Export as compact binary tiles (512 m × 512 m)
- [ ] Godot scene loads tiles within 2 km of player; unloads beyond 3 km
- [ ] One vehicle: basic arcade physics, keyboard/gamepad input
- [ ] Camera: third-person chase, collision-aware
- Pass criteria: 60 fps on a mid-range laptop while driving across 20 tiles

## Slice 1 — Living Streets (target: +6 weeks)

- [ ] Traffic AI: yield/stop logic at 10 intersection types
- [ ] OSM building footprints rendered as simple extrusions
- [ ] Pedestrian sidewalks from `highway=footway` + crossing nodes
- [ ] Save/load player position and vehicle state
- Pass criteria: 30 NPC vehicles without frame drops at an intersection

## Slice 2 — Atmosphere (target: +6 weeks)

- [ ] Procedural building generation for tiles missing OSM coverage (rural fill)
- [ ] Day-night cycle with sun position driving light and shadows
- [ ] Basic weather: rain particle + wet-road shader
- [ ] Ambient audio zones per road class (residential vs arterial)
- Pass criteria: indistinguishable from Slice 1 at a glance in a blind screenshot test

## Slice 3 — Scale (target: +8 weeks)

- [ ] Second city (candidate: a smaller Louisiana town for contrast)
- [ ] Contribution loop: in-game "report bad road" opens OSM edit URL pre-filled with location
- [ ] Auto-reimport pipeline: updated OSM data flows into tiles without rebuild
- Pass criteria: community-submitted fix appears in-game within 24 hours

## Slice 4 — Pitch (target: +4 weeks)

- [ ] Steam Next Fest build: Baton Rouge map, 3 vehicles, traffic, weather
- [ ] Analytics: session length, crash rate, tile-load latency
- [ ] Pitch deck + vertical-slice video
- Pass criteria: 1,000 wishlists or a publisher conversation

## Out of scope (v1)

- Interiors, hand-built landmarks, multiplayer, mod support, console ports
