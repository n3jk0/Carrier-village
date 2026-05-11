extends Area2D
class_name Base

var food_resources: int = 50
var wood_resources: int = 0
var stone_resources: int = 0

func _ready():
	$WoodLabel.text = "Wood: " + str(wood_resources)
	$FoodLabel.text = "Food: " + str(food_resources)


func _on_resource_returned(type: Global.ResourceType, amount: int) -> void:
	match type:
		Global.ResourceType.FOOD:
			food_resources += amount
		Global.ResourceType.WOOD:
			wood_resources += amount
		Global.ResourceType.STONE:
			stone_resources += amount
	
	Log.info("Resource returned: ", Global.ResourceType.keys()[type], " x", amount)
	_reload_labels()
	
func _reload_labels() -> void:
	$WoodLabel.text = "Wood: " + str(wood_resources)
	$FoodLabel.text = "Food: " + str(food_resources)


func _on_food_timer_timeout() -> void:
	food_resources -= Global.num_villagers
	_reload_labels()
