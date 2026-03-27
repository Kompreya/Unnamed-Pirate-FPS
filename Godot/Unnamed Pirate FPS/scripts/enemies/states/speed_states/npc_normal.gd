extends State
class_name NPCSpeedNormal
@export var move_component: EnemyMoveComponent

func Enter() -> void:
	print("normal speed set")
	%MoveComponent.entity_speed = %MoveComponent.enemy_stats.current_move_speed

func Exit() -> void:
	%MoveComponent.entity_speed = 0

func Update(_delta: float) -> void:
	pass
