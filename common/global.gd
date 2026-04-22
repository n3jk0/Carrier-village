extends Node

enum ResourceType { FOOD, WOOD, STONE }
enum VillagerState { IDLE, DRAGGING, WALKING, WORKING }
enum TaskType { NONE, GATHER_FOOD, CHOP_WOOD, BUILD }


func get_state_enum_name(value: int) -> String:
	for enum_name in VillagerState.keys():
		if VillagerState[enum_name] == value:
			return enum_name
	return "UNKNOWN"
