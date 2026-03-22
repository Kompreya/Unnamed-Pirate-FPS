extends RigidBody3D

@export var chest_loot: LootTable

@export var loot_spawn_pos: Node3D

# handler scenes
@onready var loot_global_node: Node = get_node("/root/DropHandler/Chest_Loot")

func _on_area_3d_body_entered(_body: Node3D) -> void:
	spawn_loot()
	self.queue_free()

func spawn_loot() -> void:
	var rolls: int = chest_loot.randomize_amount()
	var loot_pos: Vector3 = loot_spawn_pos.global_position
	for i:int in range(rolls):
		var instance: Node3D
		var random_loot: PackedScene = chest_loot._randomize_loot()
		instance = random_loot.instantiate()

		instance.position = loot_pos

		var up_force: int = 5
		var out_force: int = 3
		loot_global_node.add_child(instance)
		instance.apply_central_impulse(Vector3(randf_range(-out_force, out_force), up_force, randf_range(-out_force, out_force)))
