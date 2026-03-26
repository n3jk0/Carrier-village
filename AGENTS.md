# AGENTS.md - Carrier Village Development Guide

## Project Overview

This is a **Godot 4.6** game project (Carrier Village) using **GDScript**. The project uses the Forward Plus renderer and Jolt Physics for 3D physics.

## Build/Run Commands

### Running the Game
- Open the project in **Godot 4.6** editor and press F5 (Play), or
- Run from command line: `godot --path . --editor` (with editor) or `godot --path .` (headless)

### Exporting
- Use Godot editor: Project > Export
- Export presets are stored in `export_presets.cfg` (if created)

### Testing
- Godot has **no built-in test framework** for GDScript
- Manual testing via Play mode in editor
- Consider adding integration tests with custom test runners if needed

### Linting/Validation
- Godot editor provides **warnings system** - enable all warnings in Project Settings > Debug > Variable
- Key warnings to enable: `untyped_declaration`, `unsafe_call`, `unsafe_cast`
- Use: **Editor > Editor Settings > Debug > Variable** to configure

## Code Style Guidelines

### File Organization

```
project/
├── building/          # Building-related scripts and scenes
├── common/            # Shared utilities and base classes
├── component/         # Reusable game components
├── demo/              # Demo/test scenes
├── map/               # Map and world generation
├── resource/          # Custom resources (.tres files)
├── ui/                # UI scripts and scenes
├── worker/            # Worker/villager related code
└── .godot/            # Godot-generated files (ignore in git)
```

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Files | snake_case | `player_controller.gd` |
| Classes | PascalCase | `class_name StateMachine` |
| Nodes | PascalCase | `Camera2D`, `Player` |
| Functions | snake_case | `func move_player():` |
| Variables | snake_case | `var movement_speed: float` |
| Constants | CONSTANT_CASE | `const MAX_HEALTH = 100` |
| Enums | PascalCase (type), ALL_CAPS (values) | `enum Element { EARTH, WATER }` |
| Booleans | is_/can_/has_ prefix | `var is_alive: bool` |
| Signals | past tense | `signal health_changed` |

### Code Order (per Godot style guide)

1. `@tool`, `@icon`, `@static_unload` annotations
2. `class_name`
3. `extends`
4. Doc comment (`## Description`)
5. Signals
6. Enums
7. Constants
8. Static variables
9. `@export` variables
10. Regular variables
11. `@onready` variables
12. `_static_init()`
13. Static methods
14. Virtual methods (`_init`, `_ready`, `_process`, etc.)
15. Public methods
16. Private methods

### Formatting Rules

- **Indentation**: Use **tabs** (not spaces) - Godot default
- **Line length**: Keep under **100 characters**
- **Line endings**: LF only (default in Godot)
- **Encoding**: UTF-8 without BOM (default)
- **Blank lines**: Two blank lines between top-level sections
- **Spacing**: One space around operators and after commas

```gdscript
# Good
var health: int = 100
var speed: float = 10.5

func heal(amount: int) -> void:
	health += amount
	health = min(health, max_health)
	health_changed.emit(health)

# Bad
 var health:int=100  # no spaces, no type space
var speed = 10.5  # missing type hint
```

### Type Hints (Required)

Always use **static typing** for better error catching and autocomplete:

```gdscript
# Good - explicit types
var health: int = 0
var speed: float = 10.0
var name: String = "Player"

func _ready() -> void:
	pass

func move(direction: Vector2, delta: float) -> void:
	position += direction * speed * delta

# Inference when type is obvious
var items: Array[String] = []
var timers: Dictionary = {}
```

### GDScript-Specific Patterns

#### Signals
```gdscript
# Define signals with parameters
signal health_changed(old_value: int, new_value: int)
signal died

# Emit signals
health_changed.emit(health, new_health)

# Connect in _ready
health_changed.connect(_on_health_changed)

func _on_health_changed(old_value: int, new_value: int) -> void:
	print("Health changed from %d to %d" % [old_value, new_value])
```

#### Exports
```gdscript
@export var health: int = 100
@export var speed: float = 200.0
@export var character_name: String = "Hero"
@export_category("Combat")
@export var damage: int = 10
```

#### Node References
```gdscript
# Use @onready for node caching
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_bar: ProgressBar = $UI/HealthBar

# Or use type-safe get_node
var sprite: Sprite2D = get_node_or_null("Sprite2D")
```

#### Error Handling
GDScript has **no try/catch**. Use guard clauses:

```gdscript
func take_damage(amount: int) -> void:
	if amount < 0:
		push_warning("Negative damage amount")
		return
	
	health -= amount
	if health <= 0:
		die()
```

### Scene Composition

- Build entities by **combining child nodes** with focused scripts
- Avoid "god scripts" - split large scripts into focused components
- Use **composition over inheritance**
- Keep scripts under 200-300 lines when possible
- Use `class_name` for shared types across scripts

### Git Ignore

Ensure `.godot/` and `*.import` files are handled appropriately. The project has `.gitignore` - maintain it.

## Key Patterns

### Signal Direction
- **Signals go UP** (child emits, parent listens)
- **Method calls go DOWN** (parent calls child methods)
- Avoid bidirectional dependencies

### Node Access
- Use relative paths: `$NodeName` or `get_node("NodeName")`
- Avoid deep paths like `$../../../Node`
- Cache node references in `@onready` variables

### Resources
- Use custom `.tres` files for shared data
- Group related assets, scripts, and scenes together

## Godot 4.6 Specific Notes

- Uses **Jolt Physics** (configured in project.godot)
- Forward Plus renderer (3D)
- Scene files use format 3 (`.tscn` with `uid://` references)
- Autoload scripts go in `res://` and are added via Project Settings > Globals
