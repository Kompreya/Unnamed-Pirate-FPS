extends CanvasLayer

@onready var hit_rect = $ColorRect
var player_stats: PlayerStats
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	SignalBus.connect("_on_player_hit", hurt)
	PlayerStats.health_changed.connect(update_hp)

func _process(_delta: float) -> void:
	$"Coins/Coin Counter Box/Count".text = str(PlayerStats.current_treasure)

func update_hp(cur_hp, max_hp):
	$"HP/HP Box/TextureProgressBar".max_value = max_hp
	$"HP/HP Box/TextureProgressBar".value = cur_hp
	$"HP/HP Box/TextureProgressBar/HP_Amount".text = str(cur_hp) + "/" + str(max_hp)

func hurt() -> void:
	hit_rect.visible = true
	await get_tree().create_timer(0.2).timeout
	hit_rect.visible = false
