class_name ResourceSpot extends Area2D

@export var current_amount: int = 100
@export var harvest_amount: int = 5
@export var resource_type: Global.ResourceType
@export var harvest_time: float = 3.

signal resource_harvested(type: Global.ResourceType, amount: int)

func _ready() -> void:
	$Label.text = str(current_amount)

func start_harvest():
	$Timer.start(harvest_time)

func _on_timer_timeout():
	current_amount -= harvest_amount
	$Label.text = str(current_amount)
	resource_harvested.emit(resource_type, harvest_amount)

func _on_body_entered(body: Node2D) -> void:
	print(body.name, " is start harvesting!")
	start_harvest()
	
