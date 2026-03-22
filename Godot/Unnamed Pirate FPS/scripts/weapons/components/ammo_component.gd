@icon("res://addons/plenticons/icons/16x/objects/ammo-gray.png")

extends Node3D
class_name AmmoComponent

#Nodes
@export var weapon: Node3D

@export var gun_raycast: GunRaycastComponent
@export var rum_opening: Node3D

#Resources
@export var munitions: MunitionList
@export var weapon_stats: WeaponStats

@onready var weapon_type: WeaponAttributes.WeaponTypeList = weapon.weapon_attributes.weapon_type

@onready var aim_type: WeaponAttributes.AimTypeList = weapon.weapon_attributes.aim_type



@export var is_continuous: bool = false

func check_ammo() -> bool:
	return true

func create_bullet() -> void:
	match aim_type:
		WeaponAttributes.AimTypeList.PHYSICAL:
			match weapon_type:
				WeaponAttributes.WeaponTypeList.STEEL:
					var instance: Node3D

					instance = munitions.steel_bullet.instantiate()
					MunitionsEmitters.bullets.add_child(instance)
					instance.init_bullet(weapon_stats.current_normal_damage, weapon_stats.current_poise_break)
					instance.position = gun_raycast.global_position
					var bullet_dir: Vector3 = (gun_raycast.to_global(gun_raycast.target) - gun_raycast.global_position)
					instance.transform.basis = Basis.looking_at(bullet_dir, Vector3.UP)

		WeaponAttributes.AimTypeList.HITSCAN:
			match weapon_type:
				WeaponAttributes.WeaponTypeList.STEEL:
					pass
				WeaponAttributes.WeaponTypeList.SALTSPRAY:
					if SignalBus.p_xhair_col != null and SignalBus.p_xhair_col.is_in_group("enemy"):
						SignalBus.p_xhair_col.receive_normal_damage(weapon_stats.current_normal_damage)
						SignalBus.p_xhair_col.receive_saltspray_damage(weapon_stats.current_saltspray_damage)
					elif SignalBus.p_xhair_col != null and SignalBus.p_xhair_col.is_in_group("crate"):
						SignalBus.p_xhair_col.hit()
					else:
						pass
		WeaponAttributes.AimTypeList.SPLASH:
			match weapon_type:
				WeaponAttributes.WeaponTypeList.RUM:
					pass

func splash_rum() -> void:
	var instance: RigidBody3D

	while is_continuous == true:
		await get_tree().create_timer(.01).timeout

		instance = munitions.rum_drop.instantiate()
		MunitionsEmitters.bullets.add_child(instance)
		instance.init_rum(weapon_stats.current_normal_damage, weapon_stats.current_rum_stackamt)
		instance.position = rum_opening.global_position

		var up_force: int = 10
		var out_force: int = 2

		var rum_impulse: Vector3 = Vector3(randf_range(-out_force, out_force), up_force, randf_range(-out_force, out_force))
		var rum_opening_up: Basis = rum_opening.global_transform.basis
		var final_impulse: Vector3 = rum_opening_up * rum_impulse
		instance.apply_impulse(final_impulse)

#func _shoot_sharkgun():
	##if !sharkgun_anim.is_playing():
		##sharkgun_anim.play("Shoot")
		##instance = bullet_trail.instantiate()
		##
		##var crosshair_target: Vector3 = _get_crosshair_target()
		##instance.init(shark_barrel.global_position, crosshair_target)
		#
		#if aim_ray.is_colliding():
			#var collision_normal = aim_ray.get_collision_normal()
			#var collision_point = aim_ray.get_collision_point()
			#if aim_ray.get_collider().is_in_group("enemy"):
				#var instance_blood
				#instance_blood = blood_splatter.instantiate()
				#emitters_global_node.add_child(instance_blood)
				#instance_blood.global_transform.origin = collision_point
				#instance_blood.look_at(collision_point + collision_normal, Vector3.UP)
				#aim_ray.get_collider().hit()
			#elif aim_ray.get_collider().is_in_group("crate"):
				#aim_ray.get_collider().hit()
			#else:
				#var instance_spark
				#instance_spark = bullet_spark.instantiate()
				#emitters_global_node.add_child(instance_spark)
				#instance_spark.global_transform.origin = collision_point
				#instance_spark.look_at(collision_point + collision_normal, Vector3.UP)
		#bullets_global_node.add_child(instance)
