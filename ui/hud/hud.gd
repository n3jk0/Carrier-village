extends Control

const PAUSE_ICON: Texture2D = preload("res://ui/hud/icons/pause.svg")
const PLAY_ICON: Texture2D = preload("res://ui/hud/icons/play.svg")
const MAIN_MENU_SCENE: String = "res://ui/main/main_menu.tscn"

## Seconds of food left below which the food label pulses red.
@export var low_food_seconds: float = 60.0

var _idle_index: int = 0
var _low_food_tween: Tween

@onready var food_box: Control = %FoodBox
@onready var food_label: Label = %FoodLabel
@onready var food_drain_label: Label = %FoodDrainLabel
@onready var wood_label: Label = %WoodLabel
@onready var stone_label: Label = %StoneLabel
@onready var pause_button: Button = %PauseButton
@onready var population_button: Button = %PopulationButton
@onready var main_menu_button: Button = %MainMenuButton
@onready var speed_buttons: Array[Button] = [%Speed1Button, %Speed2Button, %Speed3Button]


func _ready() -> void:
	Global.resources_changed.connect(_reload_labels)
	for i: int in speed_buttons.size():
		speed_buttons[i].pressed.connect(_set_game_speed.bind(i + 1.0))
	pause_button.toggled.connect(_on_pause_toggled)
	population_button.pressed.connect(_focus_next_idle)
	main_menu_button.pressed.connect(_go_to_main_menu)
	$IdlePollTimer.timeout.connect(_reload_population)
	_reload_labels()
	_reload_population()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_go_to_main_menu()
		return
	if event.is_action_pressed("toggle_pause"):
		pause_button.button_pressed = not pause_button.button_pressed
	for i: int in speed_buttons.size():
		if event.is_action_pressed("speed_%d" % (i + 1)):
			speed_buttons[i].button_pressed = true
			_set_game_speed(i + 1.0)


# main_menu.gd resets Engine.time_scale and get_tree().paused.
func _go_to_main_menu() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)


func _set_game_speed(speed_multiplier: float) -> void:
	Engine.time_scale = speed_multiplier


func _on_pause_toggled(paused: bool) -> void:
	get_tree().paused = paused
	pause_button.icon = PLAY_ICON if paused else PAUSE_ICON


func _reload_labels() -> void:
	var drain_per_min: float = Global.num_villagers * 60.0 / Global.food_drain_interval
	food_label.text = str(Global.food_resources)
	food_drain_label.text = "−%d/min" % roundi(drain_per_min)
	wood_label.text = str(Global.wood_resources)
	stone_label.text = str(Global.stone_resources)
	var seconds_left: float = Global.food_resources * 60.0 / maxf(drain_per_min, 0.001)
	_set_low_food_warning(seconds_left < low_food_seconds)


func _set_low_food_warning(on: bool) -> void:
	if on == (_low_food_tween != null):
		return
	if on:
		_low_food_tween = create_tween().set_loops()
		_low_food_tween.tween_property(food_box, "modulate", Color(1.0, 0.3, 0.3), 0.4)
		_low_food_tween.tween_property(food_box, "modulate", Color.WHITE, 0.4)
	else:
		_low_food_tween.kill()
		_low_food_tween = null
		food_box.modulate = Color.WHITE


# ponytail: polls every 0.5 s; switch to a villager state_changed signal if villager count grows a lot.
func _reload_population() -> void:
	population_button.text = "%d · %d idle" % [Global.num_villagers, _idle_villagers().size()]


func _idle_villagers() -> Array[Villager]:
	var idle: Array[Villager] = []
	for node: Node in get_tree().get_nodes_in_group("villagers"):
		var villager: Villager = node as Villager
		if villager.task == Global.TaskType.NONE and not villager.is_dragging:
			idle.append(villager)
	return idle


func _focus_next_idle() -> void:
	var idle: Array[Villager] = _idle_villagers()
	if idle.is_empty():
		return
	_idle_index = (_idle_index + 1) % idle.size()
	Global.camera_focus_requested.emit(idle[_idle_index].global_position)
