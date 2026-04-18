extends State
class_name WalkingToSpotState

func get_state_enum() -> Global.VillagerState:
	return Global.VillagerState.WALKING_TO_SPOT
	
func enter() -> void:
	print("Entering ", get_state_enum())
	if state_machine.character:
		state_machine.character.set_target_as_current_mouse_position()

func physics_update(delta: float) -> void:
	if state_machine.character:
		state_machine.character.move(delta)
	
	if state_machine.character.velocity == Vector2.ZERO:
		state_machine.change_state(Global.VillagerState.IDLE)
