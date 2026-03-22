extends Node
#class_name PlayerStats

enum BuffableStats{
	MAX_HEALTH,
	ATTACK_DAMAGE,
	ATTACK_SPEED,
	MELEE_RANGE,
	RANGED_RANGE,
	POISE,
	FLAT_ARMOR,
	FIRE_RESIST,
	EXPLODE_RESIST,
	RUM_RESIST,
	BLEED_RESIST,
	MOVE_SPEED,
	EXPLOSION_DAMAGE,
	EXPLOSION_RADIUS,
	DETONATION_TIMER
}

signal health_depleted
signal health_changed(current_hp: int, max_hp: int)

@export_group("Health")
@export var base_max_health: int
var current_max_health: int
var health: int = 0: set = _on_health_set

@export_group("Treasure")
var current_treasure: int = 0

@export_group("Attack")
@export var base_attack_damage: int
@export var base_attack_speed: int
@export var base_melee_range: float
@export var base_ranged_range: float
var current_attack_damage: int
var current_attack_speed: int
var current_melee_range: float
var current_ranged_range: float

@export_group("Defense")
@export var base_poise: int
@export var base_flat_armor: int
@export var base_fire_resist: int
@export var base_explode_resist: int
@export var base_rum_resist: int
@export var base_bleed_resist: int

@export_group("Movement")
@export var base_move_speed: float
@export var base_sprint_mult: float
var current_move_speed: float
var current_sprint_mult: float

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
	health = current_max_health

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

	current_move_speed = base_move_speed
	current_sprint_mult = base_sprint_mult
	current_ranged_range = base_ranged_range
	current_explosion_radius = base_explosion_radius
	current_explosion_damage = base_explosion_damage
	current_max_health = base_max_health
	current_attack_damage = base_attack_damage
	current_melee_range = base_melee_range
	current_move_speed = base_move_speed

	for stat_name:String in stat_multipliers:
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, get(cur_property_name) * stat_multipliers[stat_name])

	for stat_name:String in stat_addends:
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, get(cur_property_name) + stat_addends[stat_name])


	print("max hp " + str(PlayerStats.current_max_health))
	print("current hp " + str(PlayerStats.health))

func _on_health_set(new_value: int) -> void:
	health = clampi(new_value, 0, current_max_health)
	health_changed.emit(health, current_max_health)
	if health <= 0:
		health_depleted.emit()
