extends Node3D

@export var head: Node3D
@export var camera: Camera3D

func fp_camera_look(event: InputEvent) -> void:
	rotate_y(-event.relative.x * Settings.fp_camera_sensitivity)
	camera.rotate_x(-event.relative.y * Settings.fp_camera_sensitivity)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
