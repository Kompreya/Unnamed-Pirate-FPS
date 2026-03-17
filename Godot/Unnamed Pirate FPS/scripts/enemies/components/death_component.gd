@icon("res://addons/plenticons/icons/16x/creatures/heart-white.png")

extends Node3D
class_name EnemyDeathComponent

var state_machine

@export var health_component: EnemyHealthComponent
@export var anim_tree: AnimationTree
@export var collider: Node
@export var hp_bar: Node

func _ready() -> void:
	prints(get_path(), owner.scene_file_path)
	health_component.enemy_stats.connect("health_depleted", die)
	state_machine = anim_tree.get("parameters/playback")


func die():
	#state_machine.travel("die")
	anim_tree.set("parameters/conditions/die", true)
	SignalBus.emit_signal("_enemy_died")

func cleanup() -> void:
	collider.disabled = true
	hp_bar.queue_free()
