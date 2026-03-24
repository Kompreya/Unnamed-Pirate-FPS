extends State
class_name NPCSpeedAtRest

func Enter() -> void:
	%MoveComponent.entity_speed = 0

func Exit() -> void:
	pass

func Update(_delta: float) -> void:
	pass
