extends Control

func _ready() -> void:
	Global.resources_changed.connect(_on_resource_changed)
	_reload_labels()

func _on_resource_changed() -> void:
	_reload_labels()

func _reload_labels() -> void:
	$VBoxContainer/HBoxContainer/WoodLabel.text = "🪵: " + str(Global.wood_resources)
	$VBoxContainer/HBoxContainer/FoodLabel.text = "🍎: " + str(Global.food_resources)
	$VBoxContainer/HBoxContainer/StoneLabel.text = "🪨: " + str(Global.stone_resources)
