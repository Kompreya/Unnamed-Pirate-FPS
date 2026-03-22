@icon("res://addons/plenticons/icons/16x/objects/chest-yellow.png")

extends Node3D

# Called in animation tree
# The instance position IS the position of the node. Adjust node pos in 3D as needed

var instance

@onready var loot_global_node: Node = get_node("/root/DropHandler/Chest_Loot")

@export var enemy_loot: LootTable
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func spawn_loot() -> void:
	var rolls: int = enemy_loot.randomize_amount()
	var loot_pos: Vector3 = self.global_position
	for i:int in range(rolls):
		var random_loot: PackedScene = enemy_loot._randomize_loot()
		instance = random_loot.instantiate()

		instance.position = loot_pos

		var up_force: int = 5
		var out_force: int = 3
		loot_global_node.add_child(instance)
		instance.apply_central_impulse(Vector3(randf_range(-out_force, out_force), up_force, randf_range(-out_force, out_force)))
