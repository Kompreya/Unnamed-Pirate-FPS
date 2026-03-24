extends State
class_name NPCSpeedSlow

func Enter() -> void:
	%MoveComponent.entity_speed = %MoveComponent.enemy_stats.current_move_speed / 2

func Exit() -> void:
	pass

func Update(_delta: float) -> void:
	pass
