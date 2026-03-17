extends Node3D

#@export var chest_loot: Array[ChestLoot]

@export var crate_pieces_med = load("res://scenes/crate_pieces_med.tscn")
@export var coin = load("res://scenes/items/coin.tscn")
var instance
var drop_data_script: DropData

func _ready() -> void:
	drop_data_script = get_node("/root/Drop_Data")

func crate_destroy():
	instance = crate_pieces_med.instantiate()
	instance.transform = self.transform
	get_parent().add_child(instance)	
	self.queue_free()

func _on_area_3d_crate_hit() -> void:
	var coin_amount = randi() % 2 + 1
	var crate_global_pos = global_transform.origin
	drop_data_script.drop_coin(crate_global_pos, coin_amount)
	crate_destroy()
	
	
