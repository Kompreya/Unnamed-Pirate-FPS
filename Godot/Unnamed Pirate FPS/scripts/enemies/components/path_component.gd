@icon("res://addons/plenticons/icons/16x/creatures/eye-hollow-yellow.png")

#TODO When player is dead, pathing needs to failsafe. Furthermore, animate enemies after player death, victorious?

extends Node3D
class_name EnemyPathComponent

enum PathRoutes {
	TO_NOWHERE,
	TO_PLAYER,
	TO_RANDOM_OBJECT,
	TO_RANDOM_LOCATION
}

@export var path_route: PathRoutes = PathRoutes.TO_PLAYER

var player: Node = null

@export var state_component: EnemyStateComponent
@export var move_component: Node3D

@export var nav_agent: NavigationAgent3D
@export var anim_tree: AnimationTree
#@export var status_component: EnemyStatusComponent

var next_nav_point: Vector3
var randomizer_elapsed_time: float = 0.0
var comparitor_time: float = 0.0
var random_object: Node3D
var random_loc: Vector3

#var status_state = status_component.drunk_status: set = _on_drunkstatus_change
#
#func _on_drunkstatus_change(new_state) -> void:
	#match status_state:
		#new_state.StatusList.SOBER:
			#path_route = PathRoutes.TO_PLAYER
		#new_state.StatusList.TIPSY:
			#path_route = PathRoutes.TO_RANDOM_LOCATION

func _ready() -> void:
	SignalBus.drunk_status_changed.connect(_change_path_route)
	player = get_tree().get_first_node_in_group("player")
	_get_random_object()
	_randomize_comparitor_time()

func _physics_process(delta: float) -> void:
	randomizer_elapsed_time += delta

	match path_route:
		PathRoutes.TO_PLAYER:
			path_to_player()

		PathRoutes.TO_RANDOM_OBJECT:
			if randomizer_elapsed_time >= comparitor_time:
				randomizer_elapsed_time = 0
				_get_random_object()
				_randomize_comparitor_time()
			_verify_instance()
			path_to_random_object()

		PathRoutes.TO_RANDOM_LOCATION:
			if randomizer_elapsed_time >= comparitor_time:
				randomizer_elapsed_time = 0
				_get_random_loc()
				_randomize_comparitor_time()
			path_to_random_loc()


func path_to_player() -> void:
	nav_agent.set_target_position(player.global_transform.origin)
	next_nav_point = nav_agent.get_next_path_position()

func path_to_random_object() -> void:
	nav_agent.set_target_position(random_object.global_transform.origin)
	next_nav_point = nav_agent.get_next_path_position()

func _setup_random_objects() -> Array:
	var random_targets: Array = []
	var random_target_nodes: Array[Node] = get_tree().get_nodes_in_group("random_target")
	for node:Node in random_target_nodes:
		random_targets.append(node)
	return random_targets

func _get_random_object() -> void:
	random_object = _setup_random_objects().pick_random()

func _verify_instance() -> void:
	if !is_instance_valid(random_object):
		_get_random_object()

func path_to_random_loc() -> void:
	nav_agent.set_target_position(random_loc)
	next_nav_point = nav_agent.get_next_path_position()

func _get_random_loc() -> void:
	var rand_range: float = randf_range(5, 10)
	random_loc = Vector3(randf_range(-rand_range, rand_range), 0, randf_range(-rand_range, rand_range))

func _randomize_comparitor_time() -> void:
	comparitor_time = randf_range(3.0, 7.0)

func _change_path_route(drunk_status: EnemyStateComponent.DrunkStatusList) -> void:
	match drunk_status:
		EnemyStateComponent.DrunkStatusList.SOBER:
			path_route = PathRoutes.TO_PLAYER
		EnemyStateComponent.DrunkStatusList.TIPSY:
			path_route = PathRoutes.TO_RANDOM_LOCATION
		EnemyStateComponent.DrunkStatusList.DRUNK:
			path_route = PathRoutes.TO_RANDOM_OBJECT
			#NEED FAILSAFE FOR NO RANDOM OBJECTS
