extends Area3D
class_name BodyPartComponent

enum BodyPartList {
	HEAD,
	TORSO,
	LEFT_ARM_UPPER,
	LEFT_ARM_LOWER,
	LEFT_HAND,
	RIGHT_ARM_UPPER,
	RIGHT_ARM_LOWER,
	RIGHT_HAND,
	LEFT_LEG_UPPER,
	LEFT_LEG_LOWER,
	LEFT_FOOT,
	RIGHT_LEG_UPPER,
	RIGHT_LEG_LOWER,
	RIGHT_FOOT,
	OTHER_1,
	OTHER_2,
}

enum ArmorTypeList {
	NONE,
	WOOD,
	METAL
}

@export var body_part: BodyPartList
@export var armor_type: ArmorTypeList
@export var enemy_stats: EnemyStats

func _ready() -> void:
	enemy_stats.armor_broken.connect(_armor_broken)
	SignalBus.rum_soak.connect(receive_rum_splash)
	if get_parent().status_component:
		get_parent().status_component.register_body_part(self)

#note: when adding weapon damage, pass it here as attack: Attack or something
func receive_normal_damage(normal_damage: int) -> void:
	match armor_type:
		ArmorTypeList.NONE:
			get_parent().defense_component.calculate_normal_damage(normal_damage, enemy_stats.current_normal_resist, 0)
		ArmorTypeList.WOOD:
			get_parent().defense_component.calculate_normal_damage(normal_damage, enemy_stats.current_normal_resist, enemy_stats.armor)
		ArmorTypeList.METAL:
			get_parent().defense_component.calculate_normal_damage(normal_damage, enemy_stats.current_normal_resist, enemy_stats.armor)

func receive_poise_break(poise_break: int) -> void:
	match armor_type:
		ArmorTypeList.NONE:
			get_parent().defense_component.calculate_poise_break(poise_break, enemy_stats.current_poise_resist)
		ArmorTypeList.WOOD:
			if enemy_stats.armor <= 0:
				get_parent().defense_component.calculate_poise_break(poise_break, enemy_stats.current_poise_resist)
			else:
				enemy_stats.armor = get_parent().defense_component.calculate_armor_break(poise_break, enemy_stats.armor)
		ArmorTypeList.METAL:
			pass
	print(str(enemy_stats.armor))

func receive_saltspray_damage(saltspray_damage: int) -> void:
	match armor_type:
		ArmorTypeList.NONE:
			get_parent().defense_component.calculate_saltspray_damage(saltspray_damage, enemy_stats.current_salt_resist)
		ArmorTypeList.WOOD:
			if enemy_stats.armor <= 0:
				get_parent().defense_component.calculate_saltspray_damage(saltspray_damage, enemy_stats.current_salt_resist)
			else:
				pass
		ArmorTypeList.METAL:
			enemy_stats.armor = get_parent().defense_component.calculate_armor_rust(saltspray_damage, enemy_stats.armor)

func receive_rum_splash(rum_stackamt: int) -> void:
	var final_rum_stackamt: int = get_parent().defense_component.calculate_rum_amount(rum_stackamt, enemy_stats.current_rum_resist)
	enemy_stats.rum_stacks += final_rum_stackamt


	#get_parent().status_component.add_rum_callback(get_parent().status_component.tick_down_rum, enemy_stats.rum_stacks)
	print("Body part " + str(BodyPartList.keys()[body_part].to_pascal_case()) + " rum: " + str(enemy_stats.rum_stacks))

func _armor_broken() -> void:
	#print("Armor broken!")
	pass
