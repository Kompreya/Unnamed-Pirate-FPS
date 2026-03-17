extends RigidBody3D

@onready var explosion_timer = $Explosion_Timer
@onready var explosion_area = $Area3D
@onready var explosion_visual = $MeshInstance3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("I am a bomb")

func _on_explosion_timer_timeout() -> void:
	explosion_visual.visible = true
	await get_tree().create_timer(0.2).timeout
	explosion_visual.visible = false
	for a in explosion_area.get_overlapping_areas():
		if (a.is_in_group("enemy") || a.is_in_group("crate")):
			a.hit()
	queue_free()
