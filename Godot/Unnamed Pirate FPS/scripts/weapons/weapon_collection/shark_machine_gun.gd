extends Node3D

@export var weapon_attributes: WeaponAttributes

@onready var w_type: int = weapon_attributes.weapon_type
@onready var w_types: Dictionary = weapon_attributes.WeaponTypes
