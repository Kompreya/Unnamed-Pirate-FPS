extends Resource
class_name LootTable

@export var rolls_min: int
@export var rolls_max: int

@export var loot_table: Array[Loot]

func _randomize_loot():
	var rng = RandomNumberGenerator.new()
	
	var loot = loot_table
	var _weights = []
	
	for l in loot:
		_weights.append(l.weight)
	
	var _randomize = loot[rng.rand_weighted(_weights)]
	return _randomize.item
	
func randomize_amount():
	var a = randi() % rolls_max + rolls_min
	return a
