extends Node3D

var instance
@onready var nav_region = $"../NavigationRegion3D"

@export var wave_data: Array[Wave]

signal wave_end

var wave_number: int = 0
var alive_enemies: int = 0

# Handling async sequences, to track if a sequence is still running
# May have to modify this if I want a wave to end while a bonus is still slated to occur but all enemies dead
signal enemy_seqs_end
var seq_outstnd_i: int = 0
var wave_ongoing = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	SignalBus.connect("_enemy_spawned", enemy_spawned)
	SignalBus.connect("_enemy_died", enemy_died)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("debug_wave"):
		spawn_current_wave()


func _get_random_spawn_loc(sequence):
	var spawn_nodepath = sequence.spawn_location.pick_random()
	var spawn_loc = get_node(spawn_nodepath).global_position
	return spawn_loc

func _get_random_enemy(sequence: EnemySequence):
	var rng = RandomNumberGenerator.new()

	var enemies = sequence.enemy_data
	var _weights = []

	for e in enemies:
		_weights.append(e.spawn_weight)

	var rand_data = enemies[rng.rand_weighted(_weights)]
	return rand_data.enemy_scene

func _get_random_bonus(sequence: BonusSequence):
	var rng = RandomNumberGenerator.new()

	var bonuses = sequence.bonus_data
	var _weights = []

	for b in bonuses:
		_weights.append(b.spawn_weight)

	var rand_data = bonuses[rng.rand_weighted(_weights)]
	return rand_data.bonus_scene

func spawn_current_wave() -> void:
	if wave_number < wave_data.size():
		print(str(seq_outstnd_i))
		wave_ongoing = true
		print("wave " + str(wave_number) + "started")
		var wave = wave_data[wave_number]
		assert(0 == seq_outstnd_i)
		start_enemy_seq(wave)
		start_bonus_seq(wave)
		while seq_outstnd_i: await enemy_seqs_end
		print("wave " + str(wave_number) + "done spawning")
		# FIX ENEMY COUNT. Need to iterate over wave, get total enemy count, store it, then compare for try wave
	elif wave_number >= wave_data.size():
		print("no more waves")

func start_enemy_seq(current_wave):
	for enemy_seq in current_wave.enemy_sequences:
		seq_outstnd_i += 1
		var freq = enemy_seq.spawn_freq
		var amount = enemy_seq.enemy_amount
		for i in amount:
			await get_tree().create_timer(freq).timeout
			spawn_enemy(enemy_seq)
		seq_outstnd_i -= 1
		print("enemy sequence done")
	enemy_seqs_end.emit()


func start_bonus_seq(current_wave):

	for bonus_seq in current_wave.bonus_sequences:
		seq_outstnd_i += 1
		print("bonus start " + str(seq_outstnd_i))
		var freq = bonus_seq.spawn_freq
		var amount = bonus_seq.bonus_amount
		for i in amount:
			if wave_ongoing:
				await get_tree().create_timer(freq).timeout
				spawn_bonus(bonus_seq)
		seq_outstnd_i -= 1
		print("bonus end " + str(seq_outstnd_i))

func spawn_enemy(enemy_seq):
	var random_enemy = _get_random_enemy(enemy_seq)
	instance = random_enemy.instantiate()

	var spawn_loc = _get_random_spawn_loc(enemy_seq)
	instance.position = spawn_loc

	nav_region.add_child(instance)
	print("enemy spawned at " + str(spawn_loc))

func spawn_bonus(bonus_seq):
	var random_bonus = _get_random_bonus(bonus_seq)
	instance = random_bonus.instantiate()

	var spawn_loc = _get_random_spawn_loc(bonus_seq)
	instance.position = spawn_loc + Vector3(randf_range(-1, 1), 0, randf_range(-1, 1))
	instance.rotation = Vector3(0, randf_range(0, 360), 0)

	nav_region.add_child(instance)
	print("bonus spawned at " + str(spawn_loc))

func enemy_spawned():
	alive_enemies += 1
	print("Enemy spawned, alive enemies: " + str(alive_enemies))

func enemy_died():
	alive_enemies -= 1
	print("Enemy died, alive enemies: " + str(alive_enemies))
	_try_end_wave()

func _try_end_wave():
	if alive_enemies == 0:
		wave_number += 1
		wave_ongoing = false
		seq_outstnd_i = 0
		emit_signal("wave_end")
		print("wave end signal emitted")
		print(str(seq_outstnd_i))
	else:
		pass

func _on_wave_intermission_window_next_wave() -> void:
	spawn_current_wave()
