extends State
class_name NPCSpeedNormal
@export var move_component: EnemyMoveComponent

func Enter() -> void:
	%MoveComponent.entity_speed = %MoveComponent.enemy_stats.current_move_speed

func Exit() -> void:
	pass

func Update(_delta: float) -> void:
	pass
