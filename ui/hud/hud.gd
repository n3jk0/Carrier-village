extends Control

func _ready() -> void:
	Global.resources_changed.connect(_on_resource_changed)
	$VBoxContainer/SpeedBox/Speed1Button.pressed.connect(_set_game_speed.bind(1.0))
	$VBoxContainer/SpeedBox/Speed2Button.pressed.connect(_set_game_speed.bind(2.0))
	$VBoxContainer/SpeedBox/Speed3Button.pressed.connect(_set_game_speed.bind(3.0))
	_reload_labels()

func _set_game_speed(speed_multiplier: float) -> void:
	Engine.time_scale = speed_multiplier

func _on_resource_changed() -> void:
	_reload_labels()

func _reload_labels() -> void:
	$VBoxContainer/HBoxContainer/WoodLabel.text = "🪵: " + str(Global.wood_resources)
	$VBoxContainer/HBoxContainer/FoodLabel.text = "🍎: " + str(Global.food_resources)
	$VBoxContainer/HBoxContainer/StoneLabel.text = "🪨: " + str(Global.stone_resources)
