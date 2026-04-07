@icon("res://addons/plenticons/icons/16x/2d/double-chevron-right-green.png")

extends Node3D
class_name EnemyMoveComponent

@export var state_component: EnemyStateComponent
@export var enemy_stats: EnemyStats
@export var path_component: EnemyPathComponent
@export var anim_tree: AnimationTree
@export var parent: CharacterBody3D

var entity_speed: float

func _process(_delta: float) -> void:
	parent.velocity = (path_component.next_nav_point - parent.global_transform.origin).normalized() * entity_speed
	parent.move_and_slide()
