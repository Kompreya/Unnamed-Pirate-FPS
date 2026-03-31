@icon("res://addons/plenticons/icons/16x/objects/sword-red.png")

extends Node3D
class_name EnemyMeleeComponent

@export var enemy_stats: EnemyStats
@export var anim: AnimationPlayer
@export var range_det_component: EnemyRangeDetectComponent

#State Machines
@export var melee_state_machine: NPCMeleeStateMachine
@export var rotation_state_machine: NPCRotationStateMachine
@export var speed_state_machine: NPCSpeedStateMachine

#Attack Zones
@export var zone_one: Area3D
@export var zone_two: Area3D

#Weapon Hitboxes
@export var weapon_hbox_one: Area3D
@export var weapon_hbox_two: Area3D

var is_target_in_zone: bool = false #: set = _on_zone_transition

func _ready() -> void:
	zone_one.area_entered.connect(_attack_zone_one.bind("entered"))
	zone_one.area_exited.connect(_attack_zone_one.bind("exited"))


func _attack_zone_one(area3d: Area3D, zone_transition: String) -> void:
	print(str(area3d) + " " + str(zone_transition))
	match zone_transition:
		"entered":
			is_target_in_zone = true
			print("hit zone entered!")
			if melee_state_machine:
				melee_state_machine.request_state("outward_slash")
		"exited":
			is_target_in_zone = false
			print("hit zone exited")
			if melee_state_machine:
				melee_state_machine.request_state("cancel_attacks")
				#TODO: needs to be signal
				melee_state_machine.states.outward_slash.cancel_attack()

func _on_zone_transition(_new_zone_transition: bool) -> void:
	pass
