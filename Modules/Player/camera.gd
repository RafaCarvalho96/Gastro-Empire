extends Camera3D

@export var zoomStep: float = 0.5
@export var defaultZoom: Vector3 = Vector3(0,10.5,5)
@export var maxZoom: Vector3 = Vector3(0,10.5,5)
@export var minZoom: Vector3 = Vector3(0,5,0.5)

func _ready():
	position = defaultZoom


func _unhandled_input(event):
	if event.is_action("camera_zoom_in"):
		var direction: Vector3 =  get_parent().global_position - global_position
		if global_position.y >= minZoom.y:
			global_position += direction.normalized() * zoomStep
	if event.is_action("camera_zoom_out"):
		var direction: Vector3 =  get_parent().global_position - global_position
		if global_position.y <= maxZoom.y:
			global_position -= direction.normalized() * zoomStep
	if event.is_action_released("camera_restore"):
		position = defaultZoom
		get_parent().global_rotation_degrees.y = 0
	if event.is_action_released("camera_rotate_right"):
		get_parent().global_rotation_degrees.y += 90
	if event.is_action_released("camera_rotate_left"):
		get_parent().global_rotation_degrees.y -= 90
