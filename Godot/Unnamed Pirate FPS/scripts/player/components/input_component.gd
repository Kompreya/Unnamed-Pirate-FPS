@icon("res://addons/plenticons/icons/16x/3d/torus-blue.png")

extends Node3D
class_name PlayerInputComponent

@export var move_component: PlayerMoveComponent
@export var weapon_manager: WeaponManager
@export var fp_camera: Node3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	#SETTINGS TOGGLES
	if Input.is_action_just_pressed("mouse_lock"):
		Settings.mouse_captured()

	#CAMERA MOVEMENT
	if event is InputEventMouseMotion:
		fp_camera.fp_camera_look(event)

	#CHARACTER MOVEMENT
	#Sprint
	if Input.is_action_pressed("sprint"):
		move_component.is_sprint = true
	else:
		move_component.is_sprint = false

	#Jump
	if Input.is_action_just_pressed("jump"):
		move_component.jump()

	#WEAPON SWAPPING
	if Input.is_action_just_pressed("weapon_one"):
		weapon_manager.weapon_attributes.current_weapon = weapon_manager.weapon_attributes.WeaponTypeList.STEEL

	if Input.is_action_just_pressed("weapon_two"):
		weapon_manager.weapon_attributes.current_weapon = weapon_manager.weapon_attributes.WeaponTypeList.SALTSPRAY

	if Input.is_action_just_pressed("weapon_three"):
		weapon_manager.weapon_attributes.current_weapon = weapon_manager.weapon_attributes.WeaponTypeList.RUM

func _process(_delta: float) -> void:
	#Shoot
	if Input.is_action_pressed("shoot"):
		SignalBus.request_shoot_primary.emit()

func get_input_dir() -> Vector2:
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
	return input_dir
