extends Area3D
class_name PlayerHurtboxComponent

@export var hit_stagger: float
@export var player: CharacterBody3D

func _ready() -> void:
	SignalBus.connect("player_hit", hit)

func hit(dir: Vector3, damage: int) -> void:
	if PlayerStats.health >= 1:
		SignalBus.emit_signal("_on_player_hit")
		#emit_signal("player_hit")
		PlayerStats.health -= damage
		player.velocity += dir * hit_stagger
		print("you got hit")
	elif PlayerStats.health <= 1:
		PlayerStats.health -= damage
		emit_signal("player_died")
