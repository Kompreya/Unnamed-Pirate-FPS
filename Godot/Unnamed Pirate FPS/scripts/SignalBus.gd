extends Node

@warning_ignore_start("unused_signal")

var p_xhair_col_pt: Vector3
var p_xhair_end_pt: Vector3
var p_xhair_is_col: bool
var p_xhair_col: Object

signal _on_player_hit
signal _enemy_spawned
signal _enemy_died
signal player_hit(dir: Vector3, damage: int)

#Player RayCastComponent, detects crosshair targets and modifies crosshair
#in UI to match collision detections
signal crosshair_enemy_targeted
signal crosshair_no_target

signal request_shoot_primary
signal set_current_weapon(current_weapon_type: int)

#Weapon munition signals
signal rum_soak

#Statuses
signal drunk_status_changed(new_status)
signal stun_status_changed(new_status)
