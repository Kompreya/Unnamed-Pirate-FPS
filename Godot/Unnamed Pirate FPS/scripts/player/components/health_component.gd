@icon("res://addons/plenticons/icons/16x/creatures/heart-full-red.png")

extends Node3D
class_name PlayerHealthComponent

@export var player_health: int

func _ready() -> void:
	PlayerStats.base_max_health = player_health
	
