@icon("res://addons/plenticons/icons/16x/objects/helmet-blue.png")

extends Node3D
class_name EnemyDefenseComponent

@export var health_component: EnemyHealthComponent
@export var status_component: EnemyStatusComponent

func calculate_normal_damage(normal_damage: int, normal_resist: int, current_armor: int) -> void:
	if normal_damage > 0:
		var final_normal_damage: int = clampi(((normal_damage - current_armor) - normal_resist), 1, ((normal_damage - current_armor) - normal_resist))
		health_component.damage(final_normal_damage)

func calculate_poise_break(poise_break: int, poise_resist: int, body_part: Area3D) -> void:
	var final_poise_break: int = clampi((poise_break - poise_resist), 0, poise_break)
	status_component.apply_poise_damage(final_poise_break, body_part)

func calculate_armor_break(poise_break: int, armor: int) -> int:
	var remaining_armor: int = clampi((armor - poise_break), 0, armor)
	return remaining_armor

func calculate_saltspray_damage(saltspray_damage: int, saltspray_resist: int) -> void:
	var final_saltspray_damage: int = clampi((saltspray_damage - saltspray_resist), 0, (saltspray_damage - saltspray_damage))
	health_component.damage(final_saltspray_damage)

func calculate_armor_rust(saltspray_damage: int, armor: int) -> int:
	var remaining_armor: int = clampi((armor - saltspray_damage), 0, armor)
	return remaining_armor

func calculate_rum_amount(rum_stackamt: int, rum_resist: int) -> int:
	var final_rum_stackamt: int = clampi((rum_stackamt - rum_resist), 0, (rum_stackamt - rum_resist))
	status_component.apply_rum_stackamt(final_rum_stackamt)
	return final_rum_stackamt
