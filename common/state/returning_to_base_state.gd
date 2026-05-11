extends State
class_name ReturningToBaseState

signal resource_returned(type: Global.ResourceType, amount: int)

func get_state_enum() -> Global.VillagerState:
	return Global.VillagerState.RETURNING_TO_BASE

func enter() -> void:
	super.enter()

	var base: Area2D = get_tree().get_first_node_in_group("base")
	if base and not resource_returned.is_connected(base._on_resource_returned):
		resource_returned.connect(base._on_resource_returned)


func exit() -> void:
	var base: Area2D = get_tree().get_first_node_in_group("base")

	if base and resource_returned.is_connected(base._on_resource_returned):
		resource_returned.disconnect(base._on_resource_returned)
		
	var villager: Villager = state_machine.character
	if villager:
		villager.task = Global.TaskType.NONE
		villager.harvested_amount = 0
		villager.resource_type = Global.ResourceType.NONE


func physics_update(delta: float) -> void:
	if state_machine.character:
		var villager: Villager = state_machine.character
		
		if villager.is_dragging:
			state_machine.change_state(Global.VillagerState.DRAGGING)
			return
	
		if villager.navigation_agent.is_navigation_finished():
			resource_returned.emit(villager.resource_type, villager.harvested_amount)
			state_machine.change_state(Global.VillagerState.IDLE)
		
		villager.move(delta)
