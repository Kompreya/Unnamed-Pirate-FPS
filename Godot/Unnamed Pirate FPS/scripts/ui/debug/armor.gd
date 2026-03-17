extends Label

@export var body_p: Node3D

func _ready() -> void:
	body_p.enemy_stats.armor_broken.connect(_armor_broken)
	body_p.enemy_stats.armor_changed.connect(_armor_changed)

func _armor_changed(cur, max) -> void:
	text = str(cur) + "/" + str(max) + " armor"

func _armor_broken() -> void:
	text = "Armor Broken!"
