extends State
class_name IdleState

@export var wait_time: float = 3.0
var timer: float = 0.0

func get_state_enum() -> Global.VillagerState:
	return Global.VillagerState.IDLE

func enter() -> void:
	super.enter()
	_reset_timer()

func _reset_timer() -> void:
	timer = 0.0
	
func update(_delta: float) -> void:
	if state_machine.character:
		var villager: Villager = state_machine.character
		if villager.is_dragging:
			state_machine.change_state(Global.VillagerState.DRAGGING)
			return
		
		if villager.task != Global.TaskType.NONE:
			state_machine.change_state(Global.VillagerState.WORKING)
			return
	
func physics_update(delta: float) -> void:
	if state_machine.character:
		var villager: Villager = state_machine.character
		if villager.is_dragging:
			state_machine.change_state(Global.VillagerState.DRAGGING)
			return
		
		timer += delta
		if timer >= wait_time:
			var random_point: Vector2 = villager.global_position + Vector2(randf_range(-200, 200), randf_range(-200, 200))
			villager.set_target(random_point)
			state_machine.change_state(Global.VillagerState.WALKING)
		
func exit() -> void:
	_reset_timer()
