@icon("res://addons/plenticons/icons/16x/symbols/todo-green.png")

extends Node3D
class_name EnemyStateComponent

enum LifecycleStateList {
	SPAWNING,
	ALIVE,
	DEAD,
	AFTERLIFE,
}

@export var lifecycle_state: LifecycleStateList = LifecycleStateList.ALIVE

enum MoveStateList {
	STOP,
	SLOW_WALK,
	WALK,
	RUN,
}

@export var move_state: MoveStateList = MoveStateList.WALK

enum AttackStateList {
	NONE,
	MELEE,
	RANGE,
	THROW,
	EXPLODE,
}

@export var attack_state: AttackStateList = AttackStateList.NONE

enum MeleeAttackList {
	NONE,
	OUTWARD_SLASH,
	JAB,
	THRUST_SLASH,
}

@export var melee_attack: MeleeAttackList = MeleeAttackList.NONE

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
	drunk_status = new_status
	print("new drunk status is " + str(drunk_status))
