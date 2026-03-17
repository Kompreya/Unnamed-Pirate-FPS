@icon("res://addons/plenticons/icons/16x/creatures/heart-full-red.png")

extends Node3D
class_name EnemyHealthComponent

@export var enemy_stats: EnemyStats
@export var anim_tree: Node
@export var hp_bar: Node

func _ready() -> void:
	CurseManager.apply_curses(enemy_stats)
	enemy_stats.health_changed.connect(Callable(hp_bar, "update_hp"))
	print("Pirate spawned with " + str(enemy_stats.current_max_health) + " hp")

func damage(dam: int) -> void:
	enemy_stats.health -= dam
	#emit_signal("pirate_hit")
