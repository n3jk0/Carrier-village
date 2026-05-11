extends State
class_name WorkingState

func get_state_enum() -> Global.VillagerState:
	return Global.VillagerState.WORKING

func enter() -> void:
	super.enter()
	if state_machine.character:
		var villager: Villager = state_machine.character
		if villager.target_spot:
			if not villager.target_spot.resource_harvested.is_connected(_on_resource_harvested):
				villager.target_spot.resource_harvested.connect(_on_resource_harvested)
			
			villager.target_spot.start_harvest()


func exit() -> void:
	if state_machine.character:
		var villager: Villager = state_machine.character
		if villager.target_spot:
			if villager.target_spot.resource_harvested.is_connected(_on_resource_harvested):
				villager.target_spot.resource_harvested.disconnect(_on_resource_harvested)


func _on_resource_harvested(type: Global.ResourceType, amount: int) -> void:
	Log.info("WorkingState received harvest: ", Global.ResourceType.keys()[type], " x", amount)
	
	# Later you can store this on the villager, for example:
	var villager: Villager = state_machine.character
	if villager:
		villager.set_target(Global.base_position)
		villager.harvested_amount = amount
		villager.resource_type = type
		villager.task = Global.TaskType.RETURNING_RESOURCE
	
	state_machine.change_state(Global.VillagerState.RETURNING_TO_BASE)
