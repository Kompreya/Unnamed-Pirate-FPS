extends Node

#head bob
var bob_freq: float = 2.0
var bob_amp: float = 0.08
var t_bob: float = 0.0

#fov vars
var base_fov: float = 75.0
var fov_change: float = 1.5

#first person camera
var fp_camera_sensitivity: float = 0.005

func mouse_captured() -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
