extends Resource
class_name WeaponAttributes

var current_weapon: WeaponTypes = WeaponTypes.NONE: set = _on_weapon_swap

enum WeaponTypes {
	NONE,
	STEEL,
	SALTSPRAY,
	RUM,
	SEASHRAPNEL,
	THROWABLE,
}

enum AimTypes {
	PHYSICAL,
	HITSCAN,
	SPLASH,
	THROWN,
}

@export var weapon_type: WeaponTypes
@export var aim_type: AimTypes

func _on_weapon_swap(current_weapon_type: WeaponTypes) -> void:
	SignalBus.set_current_weapon.emit(current_weapon_type)
	print(str(current_weapon_type))
