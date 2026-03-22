@icon("res://addons/plenticons/icons/16x/objects/sword-red.png")

extends Node3D
class_name EnemyMeleeComponent

var player = null
var state_machine

@export var player_path := "/root/World/Player"

@export var enemy_stats: EnemyStats
@export var anim_tree: AnimationTree
@export var anim: AnimationPlayer
@export var range_det_component: EnemyRangeDetectComponent

#Attack Zones
@export var zone_one: Area3D
@export var zone_two: Area3D

#Weapon Hitboxes
@export var weapon_hbox_one: Area3D
@export var weapon_hbox_two: Area3D

var is_target_in_zone: bool = false: set = _on_zone_transition

@onready var anim_track = anim.get_animation("animation_pack/attack")

func _ready() -> void:
	state_machine = anim_tree.get("parameters/playback")
	player = get_node(player_path)
	zone_one.area_entered.connect(_attack_zone_one.bind("entered"))
	zone_one.area_exited.connect(_attack_zone_one.bind("exited"))

func _attack_zone_one(area3d: Area3D, zone_transition: String) -> void:
	print(str(area3d) + " " + str(zone_transition))
	match zone_transition:
		"entered":
			is_target_in_zone = true
			print("entered!")
		"exited":
			is_target_in_zone = false
			print("exited")

func _process(_delta: float) -> void:
	#attack()
	pass

func _on_zone_transition(new_zone_transition: bool) -> void:
	pass
	#is_target_in_zone = new_zone_transition
	#if new_zone_transition:
		#anim_track.loop_mode = (Animation.LOOP_LINEAR)
		#anim_tree.set("parameters/conditions/attack", true)
		#print("in the zone!")
#
	#elif !new_zone_transition:
		#anim_track.loop_mode = (Animation.LOOP_NONE)
		#anim_tree.set("parameters/conditions/attack", false)
		#print("out of the zone!")


#func attack() -> void:
	#var anim_track = anim.get_animation("animation_pack/attack")
	#if range_det_component.in_melee_range:
		#anim_track.loop_mode = (Animation.LOOP_LINEAR)
		#anim_tree.set("parameters/conditions/attack", true)
	#elif !range_det_component.in_melee_range:
		#anim_track.loop_mode = (Animation.LOOP_NONE)
		#anim_tree.set("parameters/conditions/attack", false)
#
#func _hit_finished():
	#if global_position.distance_to(player.global_position) < enemy_stats.current_melee_range + 1.0:
		#var dir = global_position.direction_to(player.global_position)
		#var damage = enemy_stats.current_attack_damage
		#SignalBus.emit_signal("player_hit", dir, damage)
