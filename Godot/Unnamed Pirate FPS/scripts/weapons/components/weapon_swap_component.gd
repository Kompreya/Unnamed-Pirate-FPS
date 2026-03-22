@icon("res://addons/plenticons/icons/16x/symbols/todo-yellow.png")

extends Node3D
class_name WeaponSwapComponent

@export var weapon: Node3D
@export var anim: AnimationPlayer

var is_current_weapon: bool = false: set = _weapon_swap

func _ready() -> void:
	SignalBus.set_current_weapon.connect(_set_current_weapon)

func _set_current_weapon(swapped_weapon_type: int) -> void:
	match weapon.weapon_attributes.weapon_type:
		WeaponAttributes.WeaponTypeList.STEEL:
			if swapped_weapon_type == 1:
				is_current_weapon = true
			else:
				is_current_weapon = false
		WeaponAttributes.WeaponTypeList.SALTSPRAY:
			if swapped_weapon_type == 2:
				is_current_weapon = true
			else:
				is_current_weapon = false
		WeaponAttributes.WeaponTypeList.RUM:
			if swapped_weapon_type == 3:
				is_current_weapon = true
			else:
				is_current_weapon = false

func _weapon_swap(new_var: bool) -> void:
	if !is_current_weapon and new_var:
		await get_tree().create_timer(.25).timeout
		anim.play_backwards("Swap")
		print("raising weapon")
	elif is_current_weapon and !new_var:
		anim.play("Swap")
		print("lowering weapon")
	else:
		pass
	is_current_weapon = new_var
