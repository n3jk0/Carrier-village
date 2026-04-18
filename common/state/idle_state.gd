extends State
class_name IdleState

func get_state_enum() -> Global.VillagerState:
	return Global.VillagerState.IDLE
	
func enter() -> void:
	print("Entering IdleState")
	
func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		state_machine.change_state(Global.VillagerState.WALKING_TO_SPOT)
