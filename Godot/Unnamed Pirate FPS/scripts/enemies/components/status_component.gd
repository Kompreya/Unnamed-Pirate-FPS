@icon("res://addons/plenticons/icons/16x/2d/spark-hollow-yellow.png")

extends Node3D
class_name EnemyStatusComponent

#signal drunk_status_changed(drunk_status: DrunkStatusList)

@export var drunk_state_machine: NPCDrunkStateMachine

@export var enemy_stats: EnemyStats

@export var state_component: EnemyStateComponent
@export var move_component: EnemyMoveComponent
@export var path_component: EnemyPathComponent

@export var stun_parts: Array[BodyPartComponent]
@export var knockdown_parts: Array[BodyPartComponent]

#keep this here. Status comp holds ref to all body parts so states can access
var body_parts: Array = []
var rum_elapsed_time: float = 0.0
var last_body_part_hit: Area3D

func _ready() -> void:
	enemy_stats.poisehp_depleted.connect(_poise_broken)
	enemy_stats.drunk_state_changed.connect(_on_drunkstate_change)

func register_body_part(body_part: Area3D) -> void:
	if body_part not in body_parts:
		body_parts.append(body_part)
		print("Body part " + str(body_part) + "registered!")

# POISE
func apply_poise_damage(final_poisebreak: int, body_part: Area3D) -> void:
	print(str(final_poisebreak) + " poisebreak dealt!")
	enemy_stats.poisehp -= final_poisebreak
	last_body_part_hit = body_part
	print(str(enemy_stats.poisehp) + " poisehp remaining!")
	print("Poise hit on " + str(last_body_part_hit))

func _poise_broken() -> void:
	print("Poise Broken on " + str(last_body_part_hit))
	if last_body_part_hit in stun_parts:
		print("enemy STUNNED!")
	elif last_body_part_hit in knockdown_parts:
		print("enemy KNOCKED DOWN")
	else:
		print("poise was broken but unsure which body part was hit")
	enemy_stats.poisehp = enemy_stats.current_max_poisehp

# RUM
func apply_rum_stackamt(final_rum_stackamt: int) -> void:
	enemy_stats.rum_stacks += final_rum_stackamt
	print("Enemy rum: " + str(enemy_stats.rum_stacks))

func elapse_rum_timer(_delta: float) -> void:
	if enemy_stats.rum_stacks <= 0:
		return
	#tick up this var ea process, so I can compare stat duration against elapsed time
	rum_elapsed_time += _delta
	if rum_elapsed_time >= enemy_stats.current_rum_duration:
		rum_elapsed_time -= enemy_stats.current_rum_duration
		tickdown_rum_stackamt()

func tickdown_rum_stackamt() -> void:
	#status comp stack amt
	enemy_stats.rum_stacks = max(enemy_stats.rum_stacks - 1, 0)

	#body part stack amts
	for part:Area3D in body_parts:
		if part.enemy_stats.rum_stacks > 0:
			part.enemy_stats.rum_stacks -= 1
			print("Body part " + str(part) + " remaining rum: " + str(part.enemy_stats.rum_stacks))

	print("Enemy remaining rumstks: ", + enemy_stats.rum_stacks)

func _on_drunkstate_change(drunk_state: EnemyStats.DrunkStates) -> void:
	match drunk_state:
		EnemyStats.DrunkStates.DEPLETED:
			drunk_state_machine.request_state("depleted")
		EnemyStats.DrunkStates.SOBER:
			drunk_state_machine.request_state("sober")
		EnemyStats.DrunkStates.TIPSY:
			drunk_state_machine.request_state("tipsy")
		EnemyStats.DrunkStates.DRUNK:
			drunk_state_machine.request_state("drunk")




#func _sober() -> void:
	#drunk_status = DrunkStatusList.SOBER
	#path_component.path_route = path_component.PathRoutes.TO_PLAYER
	#move_component.move_state = move_component.MoveStates.WALK
	#print("enemy sober!")
#
#func _tipsy() -> void:
	#drunk_status = DrunkStatusList.TIPSY
	#path_component.path_route = path_component.PathRoutes.TO_RANDOM_LOCATION
	#move_component.move_state = move_component.MoveStates.DRUNK_WALK
	#print("Enemy tipsy!")
