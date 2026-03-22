extends Resource
class_name LootTable

@export var rolls_min: int
@export var rolls_max: int

@export var loot_table: Array[Loot]

func _randomize_loot() -> PackedScene:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()

	var _weights: Array = []

	for l:Loot in loot_table:
		_weights.append(l.weight)

	var _randomize: Loot = loot_table[rng.rand_weighted(_weights)]
	return _randomize.item

func randomize_amount() -> int:
	var amount: int = randi() % rolls_max + rolls_min
	return amount
