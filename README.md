# BetterVoxel scripting docs

The source of truth for the BetterVoxel scripting documentation —
the site at <https://better-voxel.github.io/bettervoxel_scripting_doc/>.

The engine repo is private; this repo is where the documentation is
written, reviewed and built. It combines two layers:

- **`model/`** — the engine's exported API model, committed here by the
  engine's CI (`api-dump.json`, the machine-readable dump;
  `bettervoxel.d.luau`, the Luau definitions; `bettervoxel-docs.json`,
  the model-level hover docs). **Never edit these by hand** — they
  regenerate from the engine and any edit is overwritten by the next
  sync.
- **`content/`** — the hand-authored layer, keyed to the dump:
  - `content/classes|datatypes|services/<Owner>.yaml` — per-member
    parameter prose, return prose, remarks and code examples. Params
    are keyed by NAME only; types live in the model and render from it,
    so there is no duplicated fact to drift.
  - `content/guides/*.md` — standalone guide pages.

`tool/` (Rust) glues them: `validate` checks every content key against
the dump — unknown members, misspelled fields and unknown parameter
names all fail with precise messages — and `generate` builds the mdBook
source tree under `book/` plus the content-merged documentation
database.

## Contributing content

1. Edit or add a YAML under `content/` (schema by example:
   `content/classes/Instance.yaml`).
2. Validate: `cargo run --manifest-path tool/Cargo.toml -- validate .`
3. (Optional) build the site locally:
   `cargo run --manifest-path tool/Cargo.toml -- generate .` then
   `mdbook build book` (mdBook 0.5.x) and open
   `target/book/index.html`.
4. Open a pull request — CI runs the same validate/generate/build.

Content is additive: a member without rich content still ships fully
documented at the engine's summary level, so partial coverage is fine.

## Editor integration

See the [Editor setup](content/guides/editor-setup.md) guide — the
published site serves the current `bettervoxel.d.luau` and
`bettervoxel-docs.json` for luau-lsp's definitions/documentation
settings.
