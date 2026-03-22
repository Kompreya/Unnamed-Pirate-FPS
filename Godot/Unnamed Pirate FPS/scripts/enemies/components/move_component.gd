@icon("res://addons/plenticons/icons/16x/2d/double-chevron-right-green.png")

extends Node3D
class_name EnemyMoveComponent

var velocity
var state_machine

@export var state_component: EnemyStateComponent
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
	match state_component.move_state:
		state_component.MoveStateList.STOP:
			stop()
		state_component.MoveStateList.WALK:
			walk(delta)
		#state_component.MoveStateList.DRUNK_WALK:
			#drunk_walk(delta)

func walk(_delta) -> void:
	parent.velocity = (path_component.next_nav_point - parent.global_transform.origin).normalized() * enemy_stats.current_move_speed

	parent.rotation.y = lerp_angle(parent.rotation.y, atan2(-parent.velocity.x, -parent.velocity.z), _delta * 10.0)
	parent.move_and_slide()

func drunk_walk(_delta) -> void:
	parent.velocity = (path_component.next_nav_point - parent.global_transform.origin).normalized() * (enemy_stats.current_move_speed / 2)
	parent.rotation.y = lerp_angle(parent.rotation.y, atan2(-parent.velocity.x, -parent.velocity.z), _delta * 10.0)
	parent.move_and_slide()

func stop() -> void:
	parent.velocity = Vector3.ZERO

func _change_move_state(drunk_status: EnemyStateComponent.DrunkStatusList) -> void:
	state_component.drunk_status = int(drunk_status)
	match drunk_status:
		EnemyStateComponent.DrunkStatusList.SOBER:
			state_component.move_state = state_component.MoveStates.WALK
		EnemyStateComponent.DrunkStatusList.TIPSY:
			state_component.move_state = state_component.MoveStates.DRUNK_WALK
		EnemyStateComponent.DrunkStatusList.DRUNK:
			state_component.move_state = state_component.MoveStates.DRUNK_WALK


#func _toggle_anim_loop() -> void:
	#var anim_track = anim.get_animation("animation_pack/attack")
	#if range_det_component.in_melee_range:
		#anim_track.loop_mode = (Animation.LOOP_LINEAR)
		#anim_tree.set("parameters/conditions/attack", true)
	#elif !range_det_component.in_melee_range:
		#anim_track.loop_mode = (Animation.LOOP_NONE)
		#anim_tree.set("parameters/conditions/attack", false)
