extends State
class_name NPCNormalRotation

@export var rot_speed: float = TAU * 2
var theta: float

@export var parent: CharacterBody3D
@export var path_component: EnemyPathComponent

func enter() -> void:
	pass

func exit() -> void:
	pass

func physics_update(delta: float) -> void:
	if path_component and parent:
		var dir: Vector3 = (parent.global_position - path_component.next_nav_point).normalized()
		theta = wrapf(atan2(dir.x, dir.z) - parent.rotation.y, -PI, PI)
		parent.rotation.y += clamp(rot_speed * delta, 0, abs(theta)) * sign(theta)
