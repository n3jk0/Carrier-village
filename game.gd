extends Node2D

## Speed of camera movement in pixels per second.
@export var camera_speed: float = 1200.0
## Speed of zooming.
@export var zoom_speed: float = 0.1
## Minimum zoom level.
@export var min_zoom: float = 0.5
## Maximum zoom level.
@export var max_zoom: float = 2.0

@onready var camera: Camera2D = $Camera2D


func _process(delta: float) -> void:
	_handle_camera_movement(delta)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_adjust_zoom(zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_adjust_zoom(-zoom_speed)


## Handles camera movement based on input actions and clamps edges to map limits.
func _handle_camera_movement(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	if direction == Vector2.ZERO:
		return
		
	var target_pos: Vector2 = camera.position + direction * (camera_speed / camera.zoom.x) * delta
	camera.position = _clamp_camera_position(target_pos)


## Adjusts the camera zoom level and re-clamps position.
func _adjust_zoom(amount: float) -> void:
	var target_zoom: float = clamp(camera.zoom.x + amount, min_zoom, max_zoom)
	camera.zoom = Vector2(target_zoom, target_zoom)
	# Re-clamp after zoom because the visible area changed
	camera.position = _clamp_camera_position(camera.position)


## Calculates the clamped position so screen edges stay within camera limits.
func _clamp_camera_position(target_pos: Vector2) -> Vector2:
	# Visible area size in world pixels
	var view_size: Vector2 = get_viewport_rect().size / camera.zoom
	var half_view: Vector2 = view_size * 0.5
	
	var res: Vector2 = target_pos
	
	# Clamp X
	var left_bound: float = camera.limit_left + half_view.x
	var right_bound: float = camera.limit_right - half_view.x
	if left_bound > right_bound:
		res.x = (camera.limit_left + camera.limit_right) * 0.5
	else:
		res.x = clamp(target_pos.x, left_bound, right_bound)
		
	# Clamp Y
	var top_bound: float = camera.limit_top + half_view.y
	var bottom_bound: float = camera.limit_bottom - half_view.y
	if top_bound > bottom_bound:
		res.y = (camera.limit_top + camera.limit_bottom) * 0.5
	else:
		res.y = clamp(target_pos.y, top_bound, bottom_bound)
		
	return res
