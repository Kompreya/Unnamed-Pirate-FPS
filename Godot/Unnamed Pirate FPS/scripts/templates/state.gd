extends Node
class_name State

@warning_ignore_start("unused_signal")

signal state_transition

var _can_exit: bool = true

func Enter() -> void:
	pass

func Exit() -> void:
	pass

func Update(_delta: float) -> void:
	pass

func Physics_Update(_delta: float) -> void:
	pass

func can_exit() -> bool:
	return _can_exit
