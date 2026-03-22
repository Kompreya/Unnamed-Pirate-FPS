@icon("res://addons/plenticons/icons/16x/objects/gun-green.png")

extends Node3D

@export var anim: AnimationPlayer
@export var ammo_component: AmmoComponent
@export var weapon_swap_component: WeaponSwapComponent

func _ready() -> void:
	SignalBus.request_shoot_primary.connect(request_primary_shoot)

func request_primary_shoot() -> void:
	if weapon_swap_component.is_current_weapon == true and !anim.is_playing():
		anim.play("Shoot")
		_request_ammo()
	else:
		pass

func _request_ammo() -> void:
	ammo_component.create_bullet()
