@icon("res://addons/plenticons/icons/16x/2d/dotspark-red.png")

extends Node3D
class_name ExplosionComponent

var player: Node = null

@export var enemy_stats: EnemyStats

@export var explosion_area: Area3D
@export var explosion_coll: CollisionShape3D
@export var anim_tree: AnimationTree
@export var anim: AnimationPlayer

func _ready() -> void:
	explosion_coll.shape.radius = enemy_stats.base_explosion_radius
	player = get_tree().get_first_node_in_group("player")

func detonate(in_range: bool) -> void:
	anim_tree.set("parameters/conditions/attack", in_range)
	anim_tree.set("parameters/attack/TimeScale/scale", enemy_stats.base_detonation_timer)

func explode() -> void:
	if global_position.distance_to(player.global_position) < enemy_stats.current_explosion_radius:
		var dir: Vector3 = global_position.direction_to(player.global_position)
		var damage: int = enemy_stats.current_explosion_damage
		SignalBus.emit_signal("player_hit", dir, damage)
		print("exploded")
	get_parent().queue_free()
