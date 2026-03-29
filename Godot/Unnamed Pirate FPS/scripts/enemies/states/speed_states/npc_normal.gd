extends State
class_name NPCSpeedNormal

@export var move_component: EnemyMoveComponent

func enter() -> void:
	if move_component:
		move_component.entity_speed = move_component.enemy_stats.current_move_speed

func exit() -> void:
	if move_component:
		move_component.entity_speed = 0
