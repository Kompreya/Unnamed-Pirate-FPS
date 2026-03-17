extends Control

@onready var wave_intermission_window: Control = $"."

signal next_wave
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wave_intermission_window.visible = false


func _on_wave_manager_wave_end() -> void:
	await get_tree().create_timer(5.0).timeout
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	wave_intermission_window.visible = true


func _on_button_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	wave_intermission_window.visible = false
	emit_signal("next_wave")


func _on_curse_test_pressed() -> void:
	var health_buff = CurseManager.health_buff
	CurseManager.buff_stacks[health_buff] += 1
	print("Curse clicked " + str(CurseManager.buff_stacks[health_buff]))
