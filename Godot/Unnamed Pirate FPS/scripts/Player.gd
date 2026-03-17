extends CharacterBody3D

var player_stats = PlayerStats


	## Shooting
	#if Input.is_action_pressed("shoot") and can_shoot:
		#match weapon:
			#weapons.PISTOL:
				#_shoot_pistol()
			#weapons.SHARKGUN:
				#_shoot_sharkgun()
		#crosshair._gun_fired()

		# TODO: Add logic for weapon swapping

	## bomb
	#if Input.is_action_just_pressed("throw_bomb"):
		#instance = bomb.instantiate()
		#instance.position = self.global_position
		#print("bomb dropped")
		#bomb_global_node.add_child(instance)

	# Weapon Swapping
	#if Input.is_action_just_pressed("weapon_one") and weapon != weapons.PISTOL:
		#_raise_weapon(weapons.PISTOL)
	#if Input.is_action_just_pressed("weapon_two") \
			#and weapon != weapons.SHARKGUN \
			#and UnlockedWeapons.unlocked_saltspray_weapons["shark_machine_gun"] == true:
		#_raise_weapon(weapons.SHARKGUN)

#func _shoot_sharkgun():
	#if !sharkgun_anim.is_playing():
		#sharkgun_anim.play("Shoot")
		#instance = bullet_trail.instantiate()
		#var crosshair_target: Vector3 = _get_crosshair_target()
		#instance.init(shark_barrel.global_position, crosshair_target)
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
		

#func _lower_weapon():
	#match weapon:
		#weapons.PISTOL:
			#weapon_switching.play("LowerPistol")
		#weapons.SHARKGUN:
			#weapon_switching.play("LowerSharkGun")
			#
#func _raise_weapon(new_weapon):
	#can_shoot = false
	#_lower_weapon()
	#await get_tree().create_timer(0.25).timeout
	#match new_weapon:
		#weapons.PISTOL:
			#weapon_switching.play_backwards("LowerPistol")
		#weapons.SHARKGUN:
			#weapon_switching.play_backwards("LowerSharkGun")
	#weapon = new_weapon
	#can_shoot = true
