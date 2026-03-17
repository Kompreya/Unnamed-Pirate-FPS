extends Node

# Curses
var health_buff: Resource = load("res://resources/Curses/health_test.tres")

var buff_stacks: Dictionary = {
	health_buff: 0
}

func apply_curses(enemy_stats: EnemyStats) -> void:
	for buff: EnemyBuff in buff_stacks.keys():
		var stacks: int = buff_stacks[buff]
		for i: int in stacks:
			enemy_stats.add_buff(buff)
			print("Buff applied: " + str(enemy_stats.current_max_health))
