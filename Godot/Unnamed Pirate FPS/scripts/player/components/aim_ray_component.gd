extends RayCast3D

func _physics_process(_delta: float) -> void:
	force_raycast_update()
	if is_colliding():
		SignalBus.p_xhair_col = get_collider()
		SignalBus.p_xhair_is_col = true
	else:
		SignalBus.p_xhair_col = null
		SignalBus.p_xhair_is_col = false
				
	SignalBus.p_xhair_col_pt = get_collision_point()
	SignalBus.p_xhair_end_pt = to_global(target_position)
