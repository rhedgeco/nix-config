# Nix Config

This is a NixOS system configuration using [Den](https://github.com/denful/den) and [import-tree](https://github.com/denful/import-tree).

## Den Core Principles

- **Aspects** are the main building block — composable, opt-in feature bundles that can carry config for multiple classes (`nixos`, `homeManager`, `darwin`, etc.)
- **`den.default`** is for unconditional global config applied to everything. **Schemas** (`den.schema.host`, `den.schema.user`) are for defining shared options/includes that need entity context. **Aspects** are for opt-in features.
- **Provides** route config across entity boundaries (host→users, user→hosts, named sub-aspects).
- **Includes** compose aspects together — can be aspect references, inline attrsets, or parametric functions dispatched by argument shape (`{ host }`, `{ host, user }`, `{ class, aspect-chain }`).
- Multiple files can contribute to the same aspect — the NixOS module system merges them.
- `_assets/` directories hold static files and are ignored by import-tree. `_<class>/` directories (e.g. `_nixos/`) are auto-routed by import-tree to that class.

### Where to Find Den Details

**Den is actively developed and has had organizational changes. If something isn't working as expected, verify the current source structure before trusting paths listed here — files may have moved or been renamed.**

- **Den source**: https://github.com/denful/den — always read the actual source when answering questions about what Den can do or how it behaves. Do not guess from docs or this file alone.
- **Docs** (may lag behind source): https://den.denful.dev/
- **Batteries source**: `modules/aspects/batteries/` in the Den repo — read these to understand what each battery actually does.
- **Aspect type system**: `nix/lib/aspects/types.nix` in the Den repo — defines how aspects, provides, includes, and freeform class keys actually work.
- **Pipeline / resolution**: `nix/lib/aspects/fx/` — the effects pipeline that resolves aspects into class modules. Also `nix/lib/resolve-entity.nix`, `nix/lib/policy-effects.nix`, `nix/lib/synthesize-policies.nix`.
- **Entity types (host/user/home)**: `nix/lib/entities/` — built-in fields and freeform behavior.
- **Aspect definitions module**: `modules/aspects/definition.nix` — auto-creates aspects for declared hosts/users.
- **Forward implementation**: `nix/lib/forward.nix` — the `forwardEach` function used by `den.batteries.forward` and all custom classes.

## Project Conventions

- Host aspects use `den.aspects.<host>.nixos` for NixOS config
- User aspects use `den.aspects.<user>.homeManager` for Home Manager config
- Aspects needing both NixOS and HM config use `provides.to-users` for the HM portion (see `steam.nix`, `niri.nix`)
- Persistence: aspects set `persist.directories` / `persist.files` in their class config; `persist.nix` wires it to impermanence via schema options
- `_assets/` directories hold static files (themes, images, configs)
- Unfree packages allowed globally via `nixpkgs.config.allowUnfree = true`
- The `sessions` HM option provides composable session parts at `~/.session/<name>/`

## Architecture Decisions

- **Flake entry**: `flake.nix` uses `lib.evalModules` with `import-tree ./modules` and passes `inputs` as `specialArgs`. Den's `flakeModule` is imported in `defaults.nix`.
- **Persist pattern**: Aspects just set `persist.directories`/`persist.files`. The schema module in `persist.nix` conditionally wires these to impermanence based on `host.persist.store` and `user.persist`.

## Useful Commands

```sh
nix repl '.'                    # enter nix repl for this flake
nix build '.#nixosConfigurations.jetpack.config.system.build.toplevel' --dry-run  # dry-run build
```

## Notes

- Keep this file updated as the project evolves. When the user establishes a new convention, preference, or gotcha, suggest adding it here — but always ask before editing this file.
- When Den source paths turn out to be wrong or outdated, update them here after confirming the correct location.
- If a debugging session reveals that this document's guidance led to confusion or wasted time, suggest improvements to the document.
- Proactively suggest CLAUDE.md updates at any point during a conversation — don't wait until the end. If a new pattern emerges, a gotcha is discovered, or something could save time in future sessions, bring it up immediately.
