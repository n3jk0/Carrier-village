extends Node

class_name StateMachine

@export var character: Villager
@export var initial_state: State
var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	if not character:
		print("Vharacter not set. Use parent node instead.")
		character = get_parent()
		
	for child in get_children():
		if child is State:
			states[child.get_state_enum()] = child
			child.state_machine = self
			
	if initial_state:
		change_state(initial_state.get_state_enum())

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func change_state(new_state: Global.VillagerState) -> void:
	if current_state:
		current_state.exit()
	
	current_state = states.get(new_state)
	
	if current_state:
		current_state.enter()
