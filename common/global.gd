extends Node

enum ResourceType { NONE, FOOD, WOOD, STONE }
enum VillagerState { IDLE, DRAGGING, WALKING, WORKING, RETURNING_TO_BASE }
enum TaskType { NONE, GATHER_FOOD, GATHER_WOOD, GATHER_STONE, BUILD, RETURNING_RESOURCE }


func get_state_enum_name(value: int) -> String:
	for enum_name in VillagerState.keys():
		if VillagerState[enum_name] == value:
			return enum_name
	return "UNKNOWN"

@export var base_position: Vector2 = Vector2(455.0, 475.0)
@export var num_villagers: int = 0
