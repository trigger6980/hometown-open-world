# Contributing

## Branching

- `main` is protected: all changes via pull request
- Feature branches: `feature/<short-name>`
- Bug fixes: `fix/<short-name>`
- Docs only: `docs/<short-name>`

## Pull requests

- One concern per PR
- Link the roadmap slice or issue it serves
- Include a test or a screenshot/loom for anything visual
- Pass CI before merge (see `.github/workflows/ci.yml`)

## Code style

- GDScript: 4-space indent, snake_case, typed where the language allows
- Rust/C++ pipeline: `cargo fmt` / `clang-format` on commit
- No new dependencies without an issue explaining why

## Data changes

- Never commit raw PBF extracts (too large). Commit the query or the normalized tile output only
- Tile format changes require a version bump in `data/export/tile_format.md`

## Reporting bad map data

If a road is wrong in-game, the right fix is upstream: open the OSM edit link for that location, correct it, and the auto-reimport pipeline picks it up. Don't patch tiles by hand.
