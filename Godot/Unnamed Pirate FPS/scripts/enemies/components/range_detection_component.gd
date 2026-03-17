@icon("res://addons/plenticons/icons/16x/creatures/eye-hollow-green.png")

extends Node3D
class_name EnemyRangeDetectComponent

# TODO: Add some enum and match for different types of range detection ie, melee class vs ranged class

var in_melee_range: bool = false
var in_gun_range: bool = false
var in_explosion_range: bool = false

var player = null
var state_machine

@export var player_path := "/root/World/Player"

@export var enemy_stats: EnemyStats
@export var parent: CharacterBody3D
@export var path_component: EnemyPathComponent
@export var move_component: EnemyMoveComponent
@export var explosion_component: Node3D
@export var melee_component: EnemyMeleeComponent
@export var gun_component: Node3D

@onready var classes = parent.classes_attributes.classes
@onready var classlist = parent.classes_attributes.classlist

func _ready() -> void:
	player = get_node(player_path)

func _process(delta: float) -> void:
	match classes:
		classlist.SWASHBUCKLER:
				in_melee_range = player_in_melee_range()
				#if melee_component:
					#melee_component.attack(in_melee_range)
				#if path_component:
					#path_component.path_to_player(delta, in_melee_range)
		#classlist.GUNNER:
				#in_gun_range = player_in_gun_range()
				#if gun_component:
					#gun_component.shoot(in_gun_range)
				#if path_component:
					#path_component.path_to_player(delta, in_gun_range)
		#classlist.POWDER_MONKEY:
				#in_explosion_range = player_in_explosion_range()
				#if explosion_component:
					#explosion_component.detonate(in_explosion_range)
				#if path_component:
					#path_component.path_to_player(delta, in_explosion_range)

func player_in_melee_range() -> bool:
	var check_range = global_position.distance_to(player.global_position) < melee_component.enemy_stats.current_melee_range
	if check_range:
		return true
	else:
		return false

func player_in_explosion_range() -> bool:
	var check_range = global_position.distance_to(player.global_position) < explosion_component.enemy_stats.current_explosion_radius
	if check_range:
		return true
	else:
		return false

func player_in_gun_range() -> bool:
	var check_range = global_position.distance_to(player.global_position) < gun_component.enemy_stats.current_ranged_range
	if check_range:
		return true
	else:
		return false
