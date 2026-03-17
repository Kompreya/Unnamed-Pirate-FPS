extends RigidBody3D

var instance

@export var chest_loot: LootTable

@onready var loot_spawn_pos = $Loot_Spawn

# handler scenes
@onready var loot_global_node = get_node("/root/DropHandler/Chest_Loot")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_area_3d_body_entered(_body: Node3D) -> void:
	spawn_loot()
	self.queue_free()

func spawn_loot() -> void:
	var rolls = chest_loot.randomize_amount()
	var loot_pos = loot_spawn_pos.global_position
	for i in range(rolls):
		var random_loot = chest_loot._randomize_loot()
		instance = random_loot.instantiate()

		instance.position = loot_pos

		var up_force = 5
		var out_force = 3
		loot_global_node.add_child(instance)
		instance.apply_central_impulse(Vector3(randf_range(-out_force, out_force), up_force, randf_range(-out_force, out_force)))
