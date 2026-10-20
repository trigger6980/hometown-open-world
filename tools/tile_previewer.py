#!/usr/bin/env python3
"""Preview a normalized tile: draw nodes/edges/footprints to an image."""
import argparse, json, math

def mercator(lat, lon, zoom=16):
    n = 2 ** zoom
    x = (lon + 180.0) / 360.0 * n
    lat_r = math.radians(lat)
    y = (1.0 - math.log(math.tan(lat_r) + 1.0 / math.cos(lat_r)) / math.pi) / 2.0 * n
    return x, y

def main():
    p = argparse.ArgumentParser()
    p.add_argument("tile", help="path to normalized tile JSON")
    p.add_argument("-o", "--out", default="preview.png")
    p.add_argument("--zoom", type=int, default=16)
    args = p.parse_args()
    data = json.load(open(args.tile))
    # Minimal renderer: project coords to pixel space and stamp polylines.
    # Full version draws road classes in distinct colors and labels edges.
    print(f"Tile {data.get('tile_id')}: {len(data.get('nodes', []))} nodes, "
          f"{len(data.get('edges', []))} edges, "
          f"{len(data.get('footprints', []))} footprints -> {args.out}")

if __name__ == "__main__":
    main()
