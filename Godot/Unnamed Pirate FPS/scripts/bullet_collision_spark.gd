extends Node3D

@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var shader_material: ShaderMaterial = particles.material_override

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shader_material.set_shader_parameter("emission", hsv_to_rgb(randi_range(1, 6), 1.0, 1.0))
	particles.amount = randi() % 6 + 2
	particles.emitting = true

func _on_gpu_particles_3d_finished() -> void:
	queue_free()

func hsv_to_rgb(hue: float, saturation: float, value: float) -> Color:
	var c: float = value * saturation
	var x: float = c * (1 - abs(fmod(hue / 60.0, 2) - 1))
	var m: float = value - c

	var r: float = 0.0
	var g: float = 0.0
	var b: float = 0.0

	if hue < 60:
		r = c
		g = x
		b = 0
	elif hue < 120:
		r = x
		g = c
		b = 0
	elif hue < 180:
		r = 0
		g = c
		b = x
	elif hue < 240:
		r = 0
		g = x
		b = c
	elif hue < 300:
		r = x
		g = 0
		b = c
	else:
		r = c
		g = 0
		b = x

	return Color(r + m, g + m, b + m)
