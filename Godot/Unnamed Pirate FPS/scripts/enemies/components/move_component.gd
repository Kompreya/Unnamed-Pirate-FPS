@icon("res://addons/plenticons/icons/16x/2d/double-chevron-right-green.png")

extends Node3D
class_name EnemyMoveComponent

enum MoveStates {
	STOP,
	WALK,
	DRUNK_WALK,
	RUN,
}

@export var move_state: MoveStates



var velocity
var state_machine

@export var enemy_stats: EnemyStats
@export var path_component: EnemyPathComponent
@export var range_det_component: EnemyRangeDetectComponent
@export var anim_tree: AnimationTree
@export var parent: CharacterBody3D

@onready var classes = parent.classes_attributes.classes
@onready var classlist = parent.classes_attributes.classlist

@export var can_move: bool = true:
	set(value):
		can_move = value

func _ready() -> void:
	SignalBus.drunk_status_changed.connect(_change_move_state)
	state_machine = anim_tree.get("parameters/playback")

func _process(delta: float) -> void:
	velocity = Vector3.ZERO
	if !can_move:
		return
	match move_state:
		MoveStates.STOP:
			stop()
		MoveStates.WALK:
			walk(delta)
		MoveStates.DRUNK_WALK:
			drunk_walk(delta)

func walk(_delta) -> void:
	#match classes:
		#classlist.SWASHBUCKLER:
			#anim_tree.set("parameters/conditions/walk", !range_det_component.in_melee_range)
		#classlist.GUNNER:
			#anim_tree.set("parameters/conditions/rifle_walk", !range_det_component.in_gun_range)
		#classlist.POWDER_MONKEY:
			#anim_tree.set("parameters/conditions/walk", !range_det_component.in_explosion_range)
	parent.velocity = (path_component.next_nav_point - parent.global_transform.origin).normalized() * enemy_stats.current_move_speed

	parent.rotation.y = lerp_angle(parent.rotation.y, atan2(-parent.velocity.x, -parent.velocity.z), _delta * 10.0)
	parent.move_and_slide()

func drunk_walk(_delta) -> void:
	#match classes:
		#classlist.SWASHBUCKLER:
			#anim_tree.set("parameters/conditions/drunk_walk", !range_det_component.in_melee_range)
		#classlist.GUNNER:
			#anim_tree.set("parameters/conditions/rifle_walk", !range_det_component.in_gun_range)
		#classlist.POWDER_MONKEY:
			#anim_tree.set("parameters/conditions/drunk_walk", !range_det_component.in_explosion_range)
	parent.velocity = (path_component.next_nav_point - parent.global_transform.origin).normalized() * (enemy_stats.current_move_speed / 2)
	parent.rotation.y = lerp_angle(parent.rotation.y, atan2(-parent.velocity.x, -parent.velocity.z), _delta * 10.0)
	parent.move_and_slide()
	#print("drunk walking")

#var anim_track = anim.get_animation("animation_pack/attack")
	#if range_det_component.in_melee_range:
		#anim_track.loop_mode = (Animation.LOOP_LINEAR)

func stop() -> void:
	#match classes:
		#classlist.SWASHBUCKLER:
			#anim_tree.set("parameters/conditions/walk", false)
		#classlist.GUNNER:
			#anim_tree.set("parameters/conditions/rifle_walk", false)
		#classlist.POWDER_MONKEY:
			#anim_tree.set("parameters/conditions/walk", false)
	parent.velocity = Vector3.ZERO

func _change_move_state(drunk_status: EnemyStatusComponent.DrunkStatusList) -> void:
	match drunk_status:
		EnemyStatusComponent.DrunkStatusList.SOBER:
			move_state = MoveStates.WALK
		EnemyStatusComponent.DrunkStatusList.TIPSY:
			move_state = MoveStates.DRUNK_WALK
		EnemyStatusComponent.DrunkStatusList.DRUNK:
			move_state = MoveStates.DRUNK_WALK


#func _toggle_anim_loop() -> void:
	#var anim_track = anim.get_animation("animation_pack/attack")
	#if range_det_component.in_melee_range:
		#anim_track.loop_mode = (Animation.LOOP_LINEAR)
		#anim_tree.set("parameters/conditions/attack", true)
	#elif !range_det_component.in_melee_range:
		#anim_track.loop_mode = (Animation.LOOP_NONE)
		#anim_tree.set("parameters/conditions/attack", false)
