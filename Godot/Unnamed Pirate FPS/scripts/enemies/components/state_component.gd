@icon("res://addons/plenticons/icons/16x/symbols/todo-green.png")

extends Node3D
class_name EnemyStateComponent

enum LifecycleStateList {
	SPAWNING,
	ALIVE,
	DEAD,
	AFTERLIFE,
}

@export var lifecycle_state: LifecycleStateList

enum MoveStateList {
	STOP,
	WALK,
	RUN,
}

@export var move_state: MoveStateList

enum StunStatusList {
	AWARE,
	STUNNED,
	KNOCKED_DOWN,
}

@export var stun_status: StunStatusList = StunStatusList.AWARE

enum DrunkStatusList {
	DEPLETED,
	SOBER,
	TIPSY,
	DRUNK,
}

@export var drunk_status: DrunkStatusList = DrunkStatusList.SOBER: set = _on_drunkstatus_change

func _on_drunkstatus_change(new_status: DrunkStatusList) -> void:
	SignalBus.drunk_status_changed.emit(new_status)
	print(str(new_status))
