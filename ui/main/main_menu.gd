extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Engine.time_scale is global and survives change_scene_to_file; the menu always runs at 1x.
	Engine.time_scale = 1.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
