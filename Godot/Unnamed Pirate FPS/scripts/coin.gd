extends RigidBody3D


func _on_area_3d_body_entered(_body: Node3D) -> void:
	PlayerStats.current_treasure += 1
	queue_free()
