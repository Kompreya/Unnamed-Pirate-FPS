extends Label

@export var status: EnemyStatusComponent

func _ready() -> void:
	status.enemy_stats.poisehp_depleted.connect(_poise_broken)
	status.enemy_stats.poisehp_changed.connect(_poise_changed)

func _poise_changed(cur, max) -> void:
	text = str(cur) + "/" + str(max) + " poise"

func _poise_broken() -> void:
	text = "Poise Broken!"
