extends Node3D

@export var intensity: float = 8.0
@onready var vanish_anim = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for pieces in self.get_children():
		if pieces is RigidBody3D:
			pieces.apply_impulse(pieces.get_child(0).position * intensity, self.global_position)
	await get_tree().create_timer(3).timeout
	vanish_anim.play("piece_vanish")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func delete():
	call_deferred("queue_free")
