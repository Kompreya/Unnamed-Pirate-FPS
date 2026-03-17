extends CharacterBody3D

@export var enemy_name: String
@export var classes_attributes: ClassesAttributes

func _ready() -> void:
	SignalBus.emit_signal("_enemy_spawned")
