class_name ResourceSpot extends Area2D

@export var current_amount: int = 100
@export var harvest_amount: int = 5
@export var restore_amount: int = 20
@export var resource_type: Global.ResourceType
@export var harvest_time: float = 3.

signal resource_harvested(type: Global.ResourceType, amount: int)

func _ready() -> void:
	resetLabel()

func start_harvest():
	$HarvestTimer.start(harvest_time)

func _on_timer_timeout():
	current_amount -= harvest_amount
	resetLabel()
	resource_harvested.emit(resource_type, harvest_amount)

func _on_restore_timer_timeout() -> void:
	current_amount += restore_amount
	resetLabel()
	

func resetLabel():
	$Label.text = str(current_amount)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		print("Harvest!")
