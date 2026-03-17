extends RayCast3D
class_name GunRaycastComponent

var target: Vector3 = _get_target()

func _physics_process(_delta: float) -> void:
	_get_target()

func _get_target() -> Vector3:
	#force_raycast_update()
	if SignalBus.p_xhair_is_col:
		target_position = to_local(SignalBus.p_xhair_col_pt)
		target = target_position
		return target_position
	elif !SignalBus.p_xhair_is_col:
		target_position = to_local(SignalBus.p_xhair_end_pt)
		target = target_position
		return target_position
	else:
		target_position = Vector3(0, 0, -0.2)
		target = target_position
		return target_position
