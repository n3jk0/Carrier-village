extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
const speed: int = 100
const villagerNames: Array = ["Joe", "Ben", "Jacob", "Martin", "David"]
var villagerName: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	villagerName = villagerNames.pick_random()
	$Label.text = villagerName


func _physics_process(_delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		velocity = Vector2.ZERO
	
	if not navigation_agent.is_navigation_finished():
		var next_pos: Vector2 = navigation_agent.get_next_path_position()
		var direction: Vector2 = (next_pos - global_position).normalized()
		velocity = direction * speed
	elif $StartMovingTimer.time_left == 0:
		$StartMovingTimer.start()
	
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var click_position: Vector2 = get_global_mouse_position()
		print("Mose clicked: ", click_position)
		set_target(click_position)

func move() -> void:
	print($NavigationAgent2D.distance_to_target())

func set_target(target_position: Vector2) -> void:
	print("Target: ", target_position)
	navigation_agent.target_position = target_position

func _on_start_moving_timer_timeout() -> void:
	var random_pos: Vector2 = Vector2(randf_range(100., 1000.), randf_range(0., 1000.))
	set_target(random_pos)
