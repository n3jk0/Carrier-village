extends Area2D
class_name Base

var food_resources: int = 50
var wood_resources: int = 0
var stone_resources: int = 0

func _ready():
	Global.food_drain_interval = $FoodTimer.wait_time
	_reload_storage()

func _on_resource_returned(type: Global.ResourceType, amount: int) -> void:
	match type:
		Global.ResourceType.FOOD:
			food_resources += amount
		Global.ResourceType.WOOD:
			wood_resources += amount
		Global.ResourceType.STONE:
			stone_resources += amount
	
	Log.info("Resource returned: ", Global.ResourceType.keys()[type], " x", amount)
	_reload_storage()
	
func _reload_storage() -> void:
	Global.wood_resources = wood_resources
	Global.food_resources = food_resources
	Global.stone_resources = stone_resources
	Global.resources_changed.emit()


func _on_food_timer_timeout() -> void:
	food_resources -= Global.num_villagers
	_reload_storage()
