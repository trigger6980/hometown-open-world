# Normalized Road Graph Schema

## Tile

- `tile_id`: string, format `{z}/{x}/{y}` (Web Mercator)
- `bounds`: [min_lat, min_lon, max_lat, max_lon]
- `version`: uint32, monotonic per tile

## Node

- `id`: int64 (OSM node id)
- `lat`, `lon`: f64
- `tags`: map<string, string> (subset: highway, crossing, traffic_signals)

## Edge (way segment between two nodes)

- `id`: int64
- `from`, `to`: node ids
- `highway_class`: enum (motorway, trunk, primary, secondary, tertiary, residential, service, footway, cycleway, other)
- `lanes`: uint8 (default 1 per direction if untagged)
- `max_speed_kmh`: uint8
- `one_way`: bool
- `name`: string (optional)
- `geometry`: polyline of intermediate node coords

## Building footprint

- `id`: int64
- `nodes`: ordered list of (lat, lon)
- `height_m`: f32 (from tags or default 3.0)
- `levels`: uint8
- `use`: enum (residential, commercial, industrial, civic, other)

## Export format

Binary, little-endian. Header: magic `HTOW`, version, tile_id, counts. Then nodes, edges, footprints packed. Full spec TBD in `tile_format.md`.
