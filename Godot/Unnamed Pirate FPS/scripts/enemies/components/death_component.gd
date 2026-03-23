@icon("res://addons/plenticons/icons/16x/creatures/heart-white.png")

extends Node3D
class_name EnemyDeathComponent

@export var state_component: EnemyStateComponent
@export var health_component: EnemyHealthComponent
@export var anim_tree: AnimationTree
@export var collider: Node
@export var hp_bar: Node

func _ready() -> void:
	prints(get_path(), owner.scene_file_path)
	health_component.enemy_stats.health_depleted.connect(die)


func die() -> void:
	state_component.lifecycle_state = state_component.LifecycleStateList.DEAD
	#anim_tree.set("parameters/conditions/die", true)
	SignalBus.emit_signal("_enemy_died")
	print("enemy DIED")

func cleanup() -> void:
	collider.disabled = true
	hp_bar.queue_free()
