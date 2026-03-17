extends RigidBody3D

@onready var area_3d: Area3D = $Area3D
@onready var shape_cast_3d: ShapeCast3D = $ShapeCast3D

@export var emitters: Emitters

var current_normal_damage: int
var current_rum_stackamt: int

func init_rum(_current_normal_damage: int, _current_rum_stackamt: int) -> void:
	current_normal_damage = _current_normal_damage
	current_rum_stackamt = _current_rum_stackamt

func _physics_process(delta: float) -> void:
	shape_cast_3d.force_shapecast_update()
	if shape_cast_3d.is_colliding():
		var collision_position: Vector3 = shape_cast_3d.get_collision_point(0)
		var collision_normal: Vector3 = shape_cast_3d.get_collision_normal(0)

		if shape_cast_3d.get_collider(0).is_in_group("enemy"):
			shape_cast_3d.get_collider(0).receive_normal_damage(current_normal_damage)
			shape_cast_3d.get_collider(0).receive_rum_splash(current_rum_stackamt)
			queue_free()
		else:
			var splat
			var splat_normal = collision_normal.normalized()
			var basis = Basis()
			basis.y = splat_normal
			basis.x = splat_normal.cross(Vector3.FORWARD).normalized()
			basis.z = basis.x.cross(basis.y).normalized()
			splat = emitters.rum_splat.instantiate()
			MunitionsEmitters.rum_splats.add_child(splat)
			splat.global_transform = Transform3D(basis, collision_position)
			#print("decal applied")
			queue_free()


#func _on_rigidbody_entered(body: Node) -> void:
	##prints(body.name, "hit at", to_global(_local_collision_position))
	#prints(body.name, "local normal is", to_global(_local_collision_normal))
#
	#var instance_splat = emitters.rum_splat.instantiate()
#
	#var global_pos = to_global(_local_collision_position)
	#var global_normal = (global_transform.basis * _local_collision_normal).normalized() #unused
#
	#instance_splat.global_position = global_pos
#
	#if global_normal != Vector3.UP:
		#instance_splat.look_at(global_pos - _local_collision_normal, Vector3.UP)
		#instance_splat.transform = transform.rotated_local(_local_collision_normal, PI/2.0)
#
	#MunitionsEmitters.emitters.add_child(instance_splat)
	#print("splash")
	#queue_free()
