extends Label

@export var status: EnemyStatusComponent

func _ready() -> void:
	status.enemy_stats.poisehp_depleted.connect(_poise_broken)
	status.enemy_stats.poisehp_changed.connect(_poise_changed)

func _poise_changed(current_poise: int, max_poise: int) -> void:
	text = str(current_poise) + "/" + str(max_poise) + " poise"

func _poise_broken() -> void:
	text = "Poise Broken!"
