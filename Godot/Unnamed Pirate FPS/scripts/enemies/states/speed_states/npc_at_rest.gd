extends State
class_name NPCSpeedAtRest

@export var move_component: EnemyMoveComponent

func enter() -> void:
	super()
	if move_component:
		move_component.entity_speed = 0
