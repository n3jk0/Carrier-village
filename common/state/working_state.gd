extends State
class_name WorkingState

func get_state_enum() -> Global.VillagerState:
	return Global.VillagerState.WORKING

func enter() -> void:
	super.enter()
	if state_machine.character:
		var villager: Villager = state_machine.character
		if villager.target_spot:
			villager.target_spot.start_harvest()
