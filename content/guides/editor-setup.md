# Editor setup

Full IDE support — typed autocomplete plus hover documentation for every
class and member — comes from two generated files: the Luau definitions
([`bettervoxel.d.luau`](bettervoxel.d.luau)) and the documentation
database ([`bettervoxel-docs.json`](bettervoxel-docs.json)).

## VS Code (luau-lsp)

Install the `luau-lsp` extension (JohnnyMorganz.luau-lsp), then add to
your `settings.json` — the platform switch keeps Roblox's built-in
types from clashing with the engine's, and the docs file only binds
when the definitions register under the same `@bettervoxel` package name:

```json
{
"luau-lsp.platform.type": "standard",
"luau-lsp.types.definitionFiles": {
"@bettervoxel": "path/to/bettervoxel.d.luau"
},
"luau-lsp.types.documentationFiles": ["path/to/bettervoxel-docs.json"]
}

```

Both settings also accept URLs — the published site serves the current
files (cached about a day; run "Luau: Redownload API Types" to
refresh):

```json
{
"luau-lsp.platform.type": "standard",
"luau-lsp.types.definitionFiles": {
"@bettervoxel": "https://better-voxel.github.io/bettervoxel_scripting_doc/bettervoxel.d.luau"
},
"luau-lsp.types.documentationFiles": ["https://better-voxel.github.io/bettervoxel_scripting_doc/bettervoxel-docs.json"]
}

```

## Command line

```sh
luau-lsp analyze --definitions=@bettervoxel=bettervoxel.d.luau your_scripts/
```

(`analyze` type-checks only — the documentation database is a hover and
signature-help surface, consumed by the language server.)
