extends Node3D

@onready var particles: GPUParticles3D = $GPUParticles3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	particles.emitting = true

func _on_gpu_particles_3d_finished() -> void:
	queue_free()
