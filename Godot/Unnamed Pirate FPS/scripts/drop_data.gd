class_name DropData
extends Node3D

@onready var drop_item_coin: PackedScene = load("res://scenes/items/coin.tscn")

# handler scenes
@onready var coins_global_node: Node = get_node("/root/DropHandler/Coins")

func drop_coin(_global_pos: Vector3, amount: int) -> void:
	for i: int in range(amount):
		var coin_instance: RigidBody3D = drop_item_coin.instantiate()
		#randomize the position a little bit so they arent lumped
		coin_instance.position = global_position + Vector3(randf_range(-1, 1), 0, randf_range(-1, 1))

		#give coins an impulse to explode out a bit
		var intensity: float = 20.0
		var impulse_dir: Vector3 = Vector3(randf_range(-1.0, 1.0), 1, randf_range(-1.0, 1.0)).normalized()
		coin_instance.apply_impulse(Vector3.ZERO, impulse_dir * intensity)
		coins_global_node.add_child(coin_instance)
