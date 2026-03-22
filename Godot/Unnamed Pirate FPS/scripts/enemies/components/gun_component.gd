@icon("res://addons/plenticons/icons/16x/symbols/crosshair-green.png")

extends Node3D
class_name GunComponent

var player: Node = null
var state_machine


@onready var bullets_global_node: Node = get_node("/root/MunitionsEmitters/Bullets")

@export var enemy_stats: EnemyStats
@export var munitions: MunitionList

@export var anim_tree: AnimationTree
@export var anim: AnimationPlayer
@export var move_component: Node3D
@export var ray_cast_component: RaycastComponent
@export var bullet_component: Node3D
@export var parent: Node3D
@export var gun_barrel: RayCast3D

@export var can_aim: bool = false:
	set(value):
		can_aim = value

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	#TODO Modify this to use state component, get rid of travel state approach
	state_machine = anim_tree.get("parameters/playback")

func _process(_delta: float) -> void:
	pass

func shoot(in_range: bool) -> void:
	var anim_track: Animation = anim.get_animation("animation_pack/rifle_fire")
	if in_range:
		aim()
		anim_track.loop_mode = (Animation.LOOP_LINEAR)
		state_machine.travel("rifle_fire")
	else:
		anim_track.loop_mode = (Animation.LOOP_NONE)

func aim() -> void:
	if can_aim:
		parent.look_at(player.global_position)
	else:
		pass

func pull_trigger() -> void:
	if ray_cast_component:
		var instance: Node3D
		instance = munitions.steel_bullet.instantiate()
		instance.init_bullet(enemy_stats.current_attack_damage)
		gun_barrel.force_raycast_update()
		instance.position = gun_barrel.global_position
		var aim_target: Vector3 = ray_cast_component.get_target()
		var bullet_dir: Vector3 = (aim_target - gun_barrel.global_position).normalized()
		instance.transform.basis = Basis.looking_at(bullet_dir, Vector3.UP)
		bullets_global_node.add_child(instance)

func _hit_finished() -> void:
	if global_position.distance_to(player.global_position) < enemy_stats.current_ranged_range + 1.0:
		var dir: Vector3 = global_position.direction_to(player.global_position)
		var damage: int = enemy_stats.current_attack_damage
		player.hit(dir, damage)
