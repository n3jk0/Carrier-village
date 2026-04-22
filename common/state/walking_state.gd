extends State
class_name WalkingState

func get_state_enum() -> Global.VillagerState:
	return Global.VillagerState.WALKING
	
func update(_delta: float) -> void:
	if state_machine.character:
		var villager: Villager = state_machine.character
		if villager.is_dragging:
			state_machine.change_state(Global.VillagerState.DRAGGING)
			return

func physics_update(delta: float) -> void:
	if state_machine.character:
		var villager: Villager = state_machine.character
		
		if villager.is_dragging:
			state_machine.change_state(Global.VillagerState.DRAGGING)
			return
	
		if villager.navigation_agent.is_navigation_finished():
			state_machine.change_state(Global.VillagerState.IDLE)
		
		villager.move(delta)
