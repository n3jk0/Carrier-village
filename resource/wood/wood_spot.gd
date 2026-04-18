class_name WoodSpot extends ResourceSpot

const TREES: Array[Variant] = [
	preload("res://resource/wood/tree_1.png"),
	preload("res://resource/wood/tree_2.png"),
	preload("res://resource/wood/tree_3.png"),
]

func _ready() -> void:
	super._ready()
	$TreeSprite.texture = TREES.pick_random()

func _on_resource_harvested(type: Global.ResourceType, amount: int) -> void:
	var type_name = Global.ResourceType.keys()[type]
	print(type_name, " hervested: ", amount)
	print("Current amount: ", current_amount)
