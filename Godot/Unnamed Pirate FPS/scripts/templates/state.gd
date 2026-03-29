extends Node
class_name State

@warning_ignore_start("unused_signal")

signal state_transition

var _can_exit: bool = true

func enter() -> void:
	pass

func exit() -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func can_exit() -> bool:
	return _can_exit
