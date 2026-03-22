extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.crosshair_enemy_targeted.connect(_enemy_targeted)
	SignalBus.crosshair_no_target.connect(_small_x_white)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if SignalBus.p_xhair_col != null and SignalBus.p_xhair_col.is_in_group("enemy"):
		_enemy_targeted()
	else:
		_small_x_white()

func _small_x_white() -> void:
	$Crosshair.self_modulate = Color(1.0, 1.0, 1.0, 1.0)

func _enemy_targeted() -> void:
	$Crosshair.self_modulate = Color(1.0, 0.0, 0.0, 1.0)

func _gun_fired() -> void:
	if !$AnimationPlayer.is_playing():
		if !$AnimationPlayer.current_animation == "gun_fire":
			$AnimationPlayer.play("gun_fire")

func _gun_hit() -> void:
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("gun_hit")
	elif $AnimationPlayer.is_playing() and $AnimationPlayer.current_animation == "gun_fire":
		$AnimationPlayer.play("gun_hit")
