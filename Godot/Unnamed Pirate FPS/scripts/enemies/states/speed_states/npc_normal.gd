extends State
class_name NPCSpeedNormal

@export var move_component: EnemyMoveComponent

func enter() -> void:
	super()
	if move_component:
		move_component.entity_speed = move_component.enemy_stats.current_move_speed
