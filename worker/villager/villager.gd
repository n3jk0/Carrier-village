extends CharacterBody2D
class_name Villager

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
const speed: int = 100
const villagerNames: Array = ["Joe", "Ben", "Jacob", "Martin", "David"]
var villagerName: String
var target_spot: ResourceSpot = null


func _ready() -> void:
	villagerName = villagerNames.pick_random()
	$Label.text = villagerName


func set_target_as_current_mouse_position() -> void:
	set_target(get_global_mouse_position())


func set_target(target_position: Vector2) -> void:
	print("Target: ", target_position)
	navigation_agent.target_position = target_position


func move(_delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
	
	if not navigation_agent.is_navigation_finished():
		var next_pos: Vector2 = navigation_agent.get_next_path_position()
		var direction: Vector2 = (next_pos - global_position).normalized()
		velocity = direction * speed
	
	move_and_slide()
