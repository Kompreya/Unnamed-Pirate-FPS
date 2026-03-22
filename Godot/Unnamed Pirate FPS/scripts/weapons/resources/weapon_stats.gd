extends Resource
class_name WeaponStats

enum BuffableStats{
	MAX_AMMO,
	BULLET_DAMAGE,
	FIRE_SPEED,
	RELOAD_SPEED,
	BULLET_RANGE,
	EXPLOSION_RANGE,
	EXPLOSION_RADIUS,
	DETONATION_TIMER
}

signal ammo_depleted
signal ammo_changed(current_ammo: int, max_ammo: int)

@export_group("Ammo")
@export var base_max_ammo: int
var current_max_ammo: int
var ammo: int = 0: set = _on_ammo_set

@export_group("Damage")
@export var base_normal_damage: int
@export var base_poise_break: int
@export var base_saltspray_damage: int
@export var base_rum_stackamt: int
@export var base_bleed_damage: int
var current_normal_damage: int
var current_poise_break: int
var current_saltspray_damage: int
var current_rum_stackamt: int
var current_bleed_damage: int

@export_group("Firerate")
@export var base_fire_speed: float
@export var base_reload_speed: float
var current_fire_speed: float
var current_reload_speed: float

@export_group("Gun Range")
@export var base_bullet_range: float
var current_bullet_range: float

#add bullet pen

@export_group("Explosives")
@export var base_explosion_damage: int
@export var base_explosion_radius: float
@export var base_detonation_timer: float
var current_explosion_damage: int
var current_explosion_radius: float
var current_detonation_timer: float

var stat_buffs: Array[EnemyBuff]

#Add recovery stats, ie, how fast enemies recover health, recover from statuses like bleeding etc

func _init() -> void:
	stat_setup.call_deferred()

func stat_setup() -> void:
	recalc_stats()
	ammo = current_max_ammo

func add_buff(buff: EnemyBuff) -> void:
	stat_buffs.append(buff)
	recalc_stats.call_deferred()

func remove_buff(buff: EnemyBuff) -> void:
	stat_buffs.erase(buff)
	recalc_stats.call_deferred()

func recalc_stats() -> void:
	var stat_multipliers: Dictionary = {}
	var stat_addends: Dictionary = {}
	for buff:EnemyBuff in stat_buffs:
		var stat_name: String = BuffableStats.keys()[buff.stat].to_lower()
		match buff.buff_type:
			EnemyBuff.BuffType.ADD:
				if not stat_addends.has(stat_name):
					stat_addends[stat_name] = 0.0
				stat_addends[stat_name] += buff.buff_amount

			EnemyBuff.BuffType.MULTIPLY:
				if not stat_multipliers.has(stat_name):
					stat_multipliers[stat_name] = 1.0
				stat_multipliers[stat_name] += buff.buff_amount

				if stat_multipliers[stat_name] < 0.0:
					stat_multipliers[stat_name] = 0.0

	current_poise_break = base_poise_break
	current_normal_damage = base_normal_damage
	current_saltspray_damage = base_saltspray_damage
	current_rum_stackamt = base_rum_stackamt

	for stat_name:String in stat_multipliers:
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, get(cur_property_name) * stat_multipliers[stat_name])

	for stat_name:String in stat_addends:
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, get(cur_property_name) + stat_addends[stat_name])

func _on_ammo_set(new_value: int) -> void:
	ammo = clampi(new_value, 0, current_max_ammo)
	ammo_changed.emit(ammo, current_max_ammo)
	if ammo <= 0:
		ammo_depleted.emit()
