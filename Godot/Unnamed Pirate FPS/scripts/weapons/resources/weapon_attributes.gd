extends Resource
class_name WeaponAttributes

var current_weapon: WeaponTypeList = WeaponTypeList.NONE: set = _on_weapon_swap

enum WeaponTypeList {
	NONE,
	STEEL,
	SALTSPRAY,
	RUM,
	SEASHRAPNEL,
	THROWABLE,
}

enum AimTypeList {
	PHYSICAL,
	HITSCAN,
	SPLASH,
	THROWN,
}

@export var weapon_type: WeaponTypeList
@export var aim_type: AimTypeList

func _on_weapon_swap(current_weapon_type: WeaponTypeList) -> void:
	SignalBus.set_current_weapon.emit(current_weapon_type)
	print(str(current_weapon_type))
