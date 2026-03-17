extends Node3D

func _on_player_player_died() -> void:
	reset() # Replace with function body.

func reset():
	get_tree().reload_current_scene()
