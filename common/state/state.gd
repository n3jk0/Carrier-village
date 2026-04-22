@abstract
class_name State extends Node

var state_machine: StateMachine

@abstract func get_state_enum() -> Global.VillagerState

func enter() -> void:
	print("Entering ", Global.get_state_enum_name(get_state_enum()))
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass
