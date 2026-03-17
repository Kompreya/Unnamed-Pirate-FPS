@icon("res://addons/plenticons/icons/16x/objects/gun-green.png")

extends Node3D
class_name WeaponManager

@export var current_cam = Camera3D
@export var weapon_attributes: WeaponAttributes

func _ready() -> void:
	weapon_attributes.current_weapon = weapon_attributes.WeaponTypes.STEEL

func _physics_process(_delta: float) -> void:
	global_rotation = current_cam.global_rotation
