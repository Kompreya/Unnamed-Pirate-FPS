extends RayCast3D
class_name RaycastComponent

@export var gun_component: GunComponent
@export var gun_barrel: RayCast3D

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	var ray_target = Vector3(0, 0, -gun_component.enemy_stats.current_ranged_range)
	target_position = ray_target
	force_raycast_update()
	get_target()

func get_target() -> Vector3:
	# Make gun's aim point at crosshair target
	force_raycast_update()
	
	var aim_ray_collision_point : Vector3 = get_collision_point()
	var aim_ray_target : Vector3 = to_global(target_position)
	var gun_barrel_target : Vector3 = gun_barrel.to_local(aim_ray_collision_point)
	
	if is_colliding():
		gun_barrel.target_position = gun_barrel_target
		gun_barrel.force_raycast_update()
		return aim_ray_collision_point
	else:
		gun_barrel.target_position = gun_barrel.to_local(aim_ray_target)
		gun_barrel.force_raycast_update()
		return aim_ray_target
