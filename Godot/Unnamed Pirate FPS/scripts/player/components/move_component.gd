@icon("res://addons/plenticons/icons/16x/2d/double-chevron-right-green.png")

extends Node3D
class_name PlayerMoveComponent

@export var move_speed: float
@export var sprint_mult: float

@export var player: CharacterBody3D
@export var head: Node3D
@export var camera: Camera3D
@export var input: PlayerInputComponent

var speed
const JUMP_VELOCITY = 4.5

var is_sprint: bool = false

func _ready() -> void:
	PlayerStats.base_move_speed = move_speed
	PlayerStats.base_sprint_mult = sprint_mult

func _physics_process(delta: float) -> void:
	gravity(delta)

	if is_sprint:
		set_speed_sprint()
	else:
		set_speed_move()

	handle_movement(delta)

	head_bob(delta)

	fov(delta)

	player.move_and_slide()

func jump() -> void:
	if player.is_on_floor():
		player.velocity.y = JUMP_VELOCITY

func gravity(delta) -> void:
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

func set_speed_sprint() -> void:
	speed = PlayerStats.current_move_speed * PlayerStats.current_sprint_mult

func set_speed_move() -> void:
	speed = PlayerStats.current_move_speed

func decelerate(direction,delta) -> void:
	player.velocity.x = lerp(player.velocity.x, direction.x * speed, delta * 7)
	player.velocity.z = lerp(player.velocity.z, direction.z * speed, delta * 7)

func move(direction) -> void:
	player.velocity.x = direction.x * speed
	player.velocity.z = direction.z * speed

func intertia(direction, delta) -> void:
	player.velocity.x = lerp(player.velocity.x, direction.x * speed, delta * 3.5)
	player.velocity.z = lerp(player.velocity.z, direction.z * speed, delta * 3.5)

func handle_movement(delta: float) -> void:
	var direction = (head.transform.basis * Vector3(input.get_input_dir().x, 0, input.get_input_dir().y)).normalized()
	if player.is_on_floor():
		if direction:
			move(direction)
		else:
			decelerate(direction, delta)
	else:
		intertia(direction, delta)

func fov(delta) -> void:
	var sprint_speed = PlayerStats.current_move_speed * PlayerStats.current_sprint_mult
	var velocity_clamped = clamp(player.velocity.length(), 0.5, sprint_speed * 2)
	var target_fov = Settings.base_fov + Settings.fov_change * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

func head_bob(delta) -> void:
	Settings.t_bob += delta * player.velocity.length() * float(player.is_on_floor())
	camera.transform.origin = _headbob(Settings.t_bob)

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * Settings.bob_freq) * Settings.bob_amp
	pos.x = cos(time * Settings.bob_freq / 2) * Settings.bob_amp
	return pos
