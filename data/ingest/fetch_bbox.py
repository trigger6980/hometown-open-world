#!/usr/bin/env python3
"""Fetch OSM data for a bounding box via Overpass API.

Usage:
    python fetch_bbox.py --bbox 30.35,-91.25,30.55,-91.05 --out br_downtown.json

Default bbox is downtown Baton Rouge.
"""
import argparse
import json
import sys
import time
import urllib.parse
import urllib.request

OVERPASS_URL = "https://overpass-api.de/api/interpreter"

QUERY_TEMPLATE = """[out:json][timeout:180];
(
  way["highway"]({bbox});
  node["highway"="traffic_signals"]({bbox});
  node["highway"="stop"]({bbox});
  node["highway"="give_way"]({bbox});
  way["building"]({bbox});
  way["highway"="footway"]({bbox});
  way["highway"="cycleway"]({bbox});
  way["natural"="water"]({bbox});
  way["landuse"]({bbox});
);
out body;
>;
out skel qt;
"""


def fetch(bbox: str, retries: int = 3) -> dict:
    query = QUERY_TEMPLATE.format(bbox=bbox)
    data = urllib.parse.urlencode({"data": query}).encode("utf-8")
    req = urllib.request.Request(
        OVERPASS_URL,
        data=data,
        headers={"User-Agent": "hometown-open-world/0.1 (trigger6980)"},
        method="POST",
    )
    last_err = None
    for attempt in range(1, retries + 1):
        try:
            with urllib.request.urlopen(req, timeout=200) as resp:
                return json.loads(resp.read().decode("utf-8"))
        except Exception as e:
            last_err = e
            print(f"attempt {attempt}/{retries} failed: {e}", file=sys.stderr)
            if attempt < retries:
                time.sleep(5 * attempt)
    raise RuntimeError(f"Overpass fetch failed after {retries} attempts: {last_err}")


def summarize(data: dict) -> dict:
    nodes = [e for e in data.get("elements", []) if e["type"] == "node"]
    ways = [e for e in data.get("elements", []) if e["type"] == "way"]
    tags = set()
    highway_classes = set()
    for e in elements_iter(data):
        t = e.get("tags", {})
        tags.update(t.keys())
        if "highway" in t:
            highway_classes.add(t["highway"])
    buildings = sum(1 for e in ways if "building" in e.get("tags", {}))
    signals = sum(1 for e in nodes if e.get("tags", {}).get("highway") == "traffic_signals")
    stops = sum(1 for e in nodes if e.get("tags", {}).get("highway") == "stop")
    return {
        "nodes": len(nodes),
        "ways": len(ways),
        "buildings": buildings,
        "traffic_signals": signals,
        "stop_signs": stops,
        "highway_classes": sorted(highway_classes),
        "tag_keys": sorted(tags),
    }


def elements_iter(data: dict):
    yield from data.get("elements", [])


def main() -> None:
    p = argparse.ArgumentParser(description="Fetch OSM data for a bbox")
    p.add_argument(
        "--bbox",
        default="30.35,-91.25,30.55,-91.05",
        help="south,west,north,east (default: downtown Baton Rouge)",
    )
    p.add_argument("--out", default="br_downtown.json", help="output JSON path")
    p.add_argument(
        "--summary-only",
        dest="summary_only",
        default=False,
        action="store_true",
        help="print summary and skip writing full JSON",
    )
    args = p.parse_args()
    print(f"fetching bbox {args.bbox} ...", flush=True)
    t0 = time.time()
    data = fetch(args.bbox)
    elapsed = time.time() - t0
    summary = summarize(data)
    summary["elapsed_sec"] = round(elapsed, 1)
    summary["bbox"] = args.bbox
    print(json.dumps(summary, indent=2))
    if not args.summary_only:
        with open(args.out, "w", encoding="utf-8") as f:
            json.dump(data, f)
        print(f"wrote {args.out}")


if __name__ == "__main__":
    main()
