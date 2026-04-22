extends State
class_name DraggingState

func get_state_enum() -> Global.VillagerState:
	return Global.VillagerState.DRAGGING

func enter() -> void:
	super.enter()
	if state_machine.character:
		var villager: Villager = state_machine.character
		villager.clear_target()
	
	
func physics_update(_delta: float) -> void:
	if state_machine.character:
		var villager: Villager = state_machine.character
		if !villager.is_dragging:
			state_machine.change_state(Global.VillagerState.IDLE)
