extends MeshInstance3D

@export var motion_radius: float = 0.3
@export var min_radius: float = 0.05
@export var max_radius: float = 0.15
@export var speed: float = 1.0
@export var blend_r: float = 0.2
const BALL_COUNT: int = 8

var phases_pos: Array = []
var phases_dir: Array = []
var phases_rad: Array = []
var mat: ShaderMaterial

@export var anim: AnimationPlayer

func _ready() -> void:
	# Make sure we have a unique material instance
	if get_surface_override_material(0) == null:
		set_surface_override_material(0, mesh.surface_get_material(0).duplicate())
	mat = get_surface_override_material(0)

	# Random phases
	for i:int in BALL_COUNT:
		phases_pos.append(Vector3(randf() * TAU, randf() * TAU, randf() * TAU))
		phases_dir.append(Vector3(randf_range(0.5, 1.5), randf_range(0.5, 1.5), randf_range(0.5, 1.5)))
		phases_rad.append(randf() * TAU)

	mat.set_shader_parameter("blend_r", blend_r)

	anim.play("Grow")

func _process(_delta: float) -> void:

	var time: float = Time.get_ticks_msec() / 1000.0 * speed

	var positions: PackedVector3Array = PackedVector3Array()
	var radii: PackedFloat32Array = PackedFloat32Array()

	for i:int in BALL_COUNT:
		var phase: Vector3 = phases_pos[i] + phases_dir[i] * time
		var pos: Vector3 = Vector3(sin(phase.x), sin(phase.y * 1.2), sin(phase.z * 0.8)) * motion_radius
		positions.append(pos as Vector3)

		var r_phase: float = phases_rad[i] + time
		radii.append(lerp(min_radius, max_radius, 0.5 + 0.5 * sin(r_phase)))

	mat.set_shader_parameter("ball_pos", positions)
	mat.set_shader_parameter("radi", radii)
