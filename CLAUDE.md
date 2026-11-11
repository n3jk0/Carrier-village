# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Carrier Village: 2D village/resource-gathering game. Godot **4.7.2**, GDScript only, statically typed. Player drags villagers onto resource spots; villagers harvest, carry the resource back to the base, and the HUD shows stockpiles.

## Commands

No test framework, linter, or build step. Godot binary is `godot` on PATH.

```bash
godot --path . --editor                                     # open editor
godot --path .                                              # run (starts main menu)
godot --headless --path . res://game.tscn --quit-after 120  # smoke-run game scene, prints script/runtime errors
godot --headless --path . --import                          # re-import assets / regenerate .godot cache
```

`godot --check-only --script <file>` is **not useful** here: it doesn't load autoloads, so every script referencing `Global`/`Log` fails with "Identifier not found". Use the headless smoke-run instead. The smoke-run does not exercise drag/drop or the gather loop (needs mouse input).

## Architecture

**Autoloads** (`project.godot`):
- `Global` (`common/global.gd`) — shared enums (`ResourceType`, `VillagerState`, `TaskType`), mirrored resource counters, `resources_changed` signal, `base_position`, `num_villagers` (incremented in `Villager._ready`, decremented in `_exit_tree`). Autoload state survives scene changes, so anything counted into `Global` must also be undone on exit.
- `Log` (`common/logger/logger.gd`) — use `Log.debug/info/warn/error(...)` (variadic, args concatenated with no separator) instead of `print`. Default `minimum_level` is INFO, so `Log.debug` is silent unless lowered.

**Scene flow**: `ui/main/main_menu.tscn` (main scene) → `change_scene_to_file("res://game.tscn")`; HUD "Menu" button / Esc goes back. `game.tscn` holds the camera controller (`game.gd`, WASD/arrows + wheel zoom clamped to `Camera2D` limits), `map/simple/map_simple.tscn` (NavigationRegion2D, resource spots, Base), villager instances, and HUD under a CanvasLayer.

**Villager state machine** (`worker/villager/`, states in `common/state/`):
- `StateMachine` node is a child of `Villager`; each `State` child registers itself keyed by `get_state_enum()` → `Global.VillagerState`. Transitions go through `state_machine.change_state(Global.VillagerState.X)`, never by node reference.
- `State` is `@abstract`; subclasses must implement `get_state_enum()`. Adding a state = add enum value to `Global.VillagerState` + new `State` script + child node under `StateMachine` in `villager.tscn`.
- States read/write villager fields directly (`task`, `target_spot`, `resource_type`, `harvested_amount`, `is_dragging`). Each state checks `is_dragging` itself and bails to `DRAGGING`.
- `IDLE` with no task wanders: after `wait_time` it picks a random nearby point → `WALKING` → back to `IDLE` on arrival.

**Gather loop**:
1. Drag/drop (`villager.gd` `_input` / `_on_input_event`) — on drop, snaps to nav mesh and point-queries for a `ResourceSpot` area; sets `target_spot` + `task`.
2. `IDLE` sees `task != NONE` → `WORKING`: connects to spot's `resource_harvested`, calls `start_harvest()` (HarvestTimer). Villager harvests where it was dropped; it does not walk to the spot.
3. Harvest signal → villager targets `Global.base_position` → `RETURNING_TO_BASE`.
4. On nav finished, state emits `resource_returned`, temporarily connected to the node in group `"base"` (`Base._on_resource_returned`), then clears task → `IDLE`.

**Resources**: `Base` (`building/base/base.gd`) owns the authoritative counts, mirrors them into `Global.*_resources` and emits `Global.resources_changed`; `ui/hud/hud.gd` listens. Never write `Global.*_resources` directly — Base overwrites them on the next sync. FoodTimer drains food by `Global.num_villagers`. `ResourceSpot` (`resource/resource_spot.gd`) is the base scene; food/wood/stone spots are inherited scenes (`WoodSpot` adds random tree sprite).

**Game speed**: HUD buttons set `Engine.time_scale` (1x/2x/3x). It is global and survives scene changes, so `main_menu.gd` resets it; camera panning in `game.gd` divides delta by `time_scale` to stay real-time. Anything that should ignore game speed must do the same.

**Pause**: HUD pause (Space) sets `get_tree().paused`, never `time_scale = 0` (would divide by zero in `game.gd`). `Game` root is `process_mode` Always so camera and HUD keep running; `MapSimple` and each villager instance in `game.tscn` are set to Pausable. Any new gameplay node added directly under `Game` must be set Pausable too, or it keeps running while paused. `main_menu.gd` resets `paused`.

`demo/movable/` is a standalone prototype scene, not part of the game.

## Design docs

Game design lives in the Obsidian vault, `~/Documents/Obsidian Vault/Personal/GameDev/Carrier Village/`: `mini-game-plan.md` (phased roadmap, scope rules, backlog), `genre-mechanics-and-market-analysis.md` (direction: Virtual Villagers style, few villagers, individuals matter), `carrier-village-lost-expansion.md` (post-Phase-5 expansion, not to start yet). Scope rule from the roadmap: don't implement backlog ideas (enemies, second building type, weather, etc.) unless asked.

## Gotchas

- `Global.base_position` is a hardcoded Vector2, not read from the Base node — moving Base in the map requires updating it.
- Many signal connections live in `.tscn` files (`[connection ...]`), not code. Renaming a handler in `.gd` needs the scene updated too. Dangling connections fail silently (the smoke-run prints nothing) — e.g. `base.tscn` → `_on_body_entered` and `map_simple.tscn` spot `input_event` → `_on_input_event` currently have no handler.
- `ResourceSpot` has one shared `HarvestTimer`: a second villager's `start_harvest()` restarts it, and every connected villager gets `resource_harvested` while `current_amount` drops once, so resources duplicate. Known bug, fix is a per-villager work timer.
- Physics layers: 1 Terrain, 2 Player, 3 Resource_spot, 4 Building.
- Scripts/resources are referenced by `uid://`; keep `.uid` files alongside `.gd` files when moving/renaming (prefer doing moves in the editor).
- `addons/rider-plugin` is third-party (JetBrains Rider integration); don't edit. `.mcp.json` points at the Rider MCP server.
- Style: tabs, static types on all vars/params/returns, `##` doc comments on exports and public funcs, Godot style-guide ordering.
