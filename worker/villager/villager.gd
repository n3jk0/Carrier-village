extends CharacterBody2D
class_name Villager

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
const speed: int = 100
const villagerNames: Array = ["Joe", "Ben", "Jacob", "Martin", "David"]
var villagerName: String
var target_spot: ResourceSpot = null
var is_dragging: bool = false


func _ready() -> void:
	villagerName = villagerNames.pick_random()
	$Label.text = villagerName


func _input(event: InputEvent) -> void:
	if is_dragging and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed:
			is_dragging = false
			
			# Check if dropped in a navigable area
			var map: RID = navigation_agent.get_navigation_map()
			var closest_point: Vector2 = NavigationServer2D.map_get_closest_point(map, global_position)
			
			if global_position.distance_to(closest_point) > 1.0:
				print("Dropped outside navigation region. Snapping to closest point.")
				global_position = closest_point
			
			print("Dropped ", villagerName)


func _process(_delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position()


func set_target_as_current_mouse_position() -> void:
	set_target(get_global_mouse_position())


func set_target(target_position: Vector2) -> void:
	print("Target: ", target_position)
	navigation_agent.target_position = target_position


func move(_delta: float) -> void:
	if is_dragging:
		return
		
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
	
	if not navigation_agent.is_navigation_finished():
		var next_pos: Vector2 = navigation_agent.get_next_path_position()
		var direction: Vector2 = (next_pos - global_position).normalized()
		velocity = direction * speed
	
	move_and_slide()


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			print("Selected character and started dragging!")
			# Optional: Reset navigation when picking up
			velocity = Vector2.ZERO
			clear_target()


## Clears the current navigation target by setting it to the villager's position.
func clear_target() -> void:
	navigation_agent.target_position = global_position
	target_spot = null
