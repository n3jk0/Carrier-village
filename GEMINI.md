# GEMINI.md - Carrier Village Development Context

## Project Overview
Carrier Village is a **Godot 4.6** village management game prototype built with **GDScript**. Players manage villagers (workers) to gather resources and expand the village.

### Key Technologies
- **Engine**: Godot 4.6 (Forward Plus renderer)
- **Physics**: Jolt Physics (3D)
- **Language**: GDScript (Strictly typed)
- **Navigation**: Built-in Godot Navigation (2D)

### Architecture
- **State Machine**: Villagers use a state-driven architecture (see `common/state/`).
- **Autoloads**:
  - `Global`: Manages shared enums (`ResourceType`, `VillagerState`, `TaskType`).
  - `SelectionManager`: Handles unit selection logic.
- **Resource System**: `ResourceSpot` (Area2D) nodes represent harvestable entities like food and wood.

## Building and Running
The project is a standard Godot project.

### Running the Game
- **Editor**: Open `project.godot` in Godot 4.6+ and press `F5`.
- **CLI**: `godot --path .` (Requires Godot in PATH).

### Exporting
- Use **Project > Export** in the Godot editor. Configuration is managed via `export_presets.cfg`.

### Testing
- Manual testing is currently performed via the `demo/` scenes and main `game.tscn`.
- TODO: Implement automated tests using a framework like GUT (Godot Unit Test) if needed.

## Development Conventions

### File Organization
- `building/`: Building logic and scenes.
- `common/`: Core architecture (states, autoloads, shared base classes).
- `component/`: Reusable game components.
- `demo/`: Experimental and demonstration scenes.
- `map/`: Tilesets, world generation, and map-specific assets.
- `resource/`: Resource spots and data.
- `worker/`: Villager-specific logic and state machines.

### Naming & Style (Strict Adherence)
- **Files**: `snake_case` (e.g., `villager_controller.gd`).
- **Classes**: `PascalCase` with explicit `class_name`.
- **Variables/Functions**: `snake_case`.
- **Type Hints**: **Required** for all declarations (e.g., `var speed: float = 10.0`).
- **Indentation**: Use **Tabs** (Godot default).
- **Doc Comments**: Use `##` for documentation that appears in the editor.

### Design Patterns
- **Composition over Inheritance**: Prefer building entities with child nodes and focused scripts.
- **Signal Direction**: Signals go **UP** (child to parent), method calls go **DOWN** (parent to child).
- **State Machine**: Use the pattern defined in `common/state/state.gd`. Each state should override `enter`, `exit`, `update`, and `physics_update`.

## Key Files
- `project.godot`: Main project configuration.
- `common/global.gd`: Central registry for enums and global constants.
- `worker/villager/villager.gd`: Core logic for the worker unit.
- `resource/resource_spot.gd`: Base logic for interactable resources.
- `AGENTS.md`: Detailed developer guide and formatting rules.
