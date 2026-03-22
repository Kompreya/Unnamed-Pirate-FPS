extends Node3D

const SPEED: float = 40.0
var current_normal_damage: int
var current_poise_break: int

@onready var ray: RayCast3D = $RayCast3D

@export var emitters: Emitters

func init_bullet(_current_normal_damage: int, _current_poise_break: int) -> void:
	current_poise_break = _current_poise_break
	current_normal_damage = _current_normal_damage
	print(str(current_normal_damage))

func _process(delta: float) -> void:
	var step: float = SPEED * delta
	ray.target_position = Vector3(0, 0, -step)
	ray.force_raycast_update()
	if ray.is_colliding():

		var collision_normal: Vector3 = ray.get_collision_normal()
		var collision_point: Vector3 = ray.get_collision_point()


		if ray.get_collider().is_in_group("enemy"):
			var instance_blood: Node3D
			instance_blood = emitters.blood_splatter.instantiate()
			MunitionsEmitters.emitters.add_child(instance_blood)
			instance_blood.global_transform.origin = collision_point
			instance_blood.look_at(collision_point + collision_normal, Vector3.UP)
			ray.get_collider().receive_normal_damage(current_normal_damage)
			ray.get_collider().receive_poise_break(current_poise_break)
		elif ray.get_collider().is_in_group("crate"):
			ray.get_collider().hit()
		elif ray.get_collider().is_in_group("player"):
			var dir: Vector3 = global_position.direction_to(ray.get_collider().global_position)
			SignalBus.player_hit.emit(dir, current_normal_damage)
		else:
			var instance_spark: Node3D
			instance_spark = emitters.bullet_spark.instantiate()
			MunitionsEmitters.emitters.add_child(instance_spark)
			instance_spark.global_transform.origin = collision_point
			instance_spark.look_at(collision_point + collision_normal, Vector3.UP)
		print(str(to_global(collision_point)))
		queue_free()

	position += transform.basis * Vector3(0, 0, -step)
