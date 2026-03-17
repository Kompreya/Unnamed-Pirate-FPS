extends Resource
class_name EnemyStats

enum BuffableStats {
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

enum DrunkStates {
	DEPLETED,
	SOBER,
	TIPSY,
	DRUNK
}

signal health_depleted
signal health_changed(current_hp: int, max_hp: int)

signal poisehp_depleted
signal poisehp_changed(current_poisehp: int, max_poisehp: int)

signal armor_broken
signal armor_changed(current_armor: int, max_armor: int)

signal rumstacks_depleted
signal rumstacks_changed(rum_stacks: int)
signal drunk_state_changed(drunk_state: DrunkStates)
signal rum_sober
signal rum_tipsy
signal rum_drunk

@export_group("Health")
@export var base_max_health: int
var current_max_health: int
var health: int = 0: set = _on_health_set

@export_group("Status")
@export var base_max_poisehp: int
var current_max_poisehp: int
var poisehp: int = 0: set = _on_poisehp_set

@export var rum_tipsy_threshold: int
@export var rum_drunk_threshold: int
var rum_stacks: int = 0: set = _on_rumstack_set

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
@export var base_max_armor: int
@export var base_normal_resist: int
@export var base_poise_resist: int
@export var base_salt_resist: int
@export var base_rum_resist: int
@export var base_bleed_resist: int
@export var base_fire_resist: int
@export var is_breakable: bool
var current_max_armor: int
var current_normal_resist: int
var current_poise_resist: int
var current_salt_resist: int
var current_rum_resist: int
var current_bleed_resist: int
var current_fire_resist: int

var armor: int = 0: set = _on_armor_set

# THESE SET HOW LONG EA STACK TICKS DOWN 1
@export_group("Durations")
@export var base_stun_duration: float
@export var base_rust_duration: float
@export var base_rum_duration: float
@export var base_bleed_duration: float
@export var base_burn_duration: float
var current_stun_duration: float
var current_rust_duration: float
var current_rum_duration: float
var current_bleed_duration: float
var current_burn_duration: float

@export_group("Movement")
@export var base_move_speed: float
var current_move_speed: float

@export_group("Explosives")
@export var base_explosion_damage: int
@export var base_explosion_radius: float
@export var base_detonation_timer: float
var current_explosion_damage: int
var current_explosion_radius: float
var current_detonation_timer: float

var stat_buffs: Array[EnemyBuff]

func _init() -> void:
	stat_setup.call_deferred()

func stat_setup() -> void:
	recalc_stats()
	health = current_max_health
	poisehp = current_max_poisehp
	armor = current_max_armor

func add_buff(buff: EnemyBuff) -> void:
	stat_buffs.append(buff)
	recalc_stats.call_deferred()

func remove_buff(buff: EnemyBuff) -> void:
	stat_buffs.erase(buff)
	recalc_stats.call_deferred()

func recalc_stats() -> void:
	var stat_multipliers: Dictionary = {}
	var stat_addends: Dictionary = {}
	for buff: EnemyBuff in stat_buffs:
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

	current_rum_duration = base_rum_duration
	current_max_armor = base_max_armor
	current_normal_resist = base_normal_resist
	current_poise_resist = base_poise_resist
	current_ranged_range = base_ranged_range
	current_explosion_radius = base_explosion_radius
	current_explosion_damage = base_explosion_damage
	current_max_poisehp = base_max_poisehp
	current_max_health = base_max_health
	current_attack_damage = base_attack_damage
	current_melee_range = base_melee_range
	current_move_speed = base_move_speed

	for stat_name: String in stat_multipliers:
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, get(cur_property_name) * stat_multipliers[stat_name])

	for stat_name: String in stat_addends:
		var cur_property_name: String = str("current_" + stat_name)
		set(cur_property_name, get(cur_property_name) + stat_addends[stat_name])

func _on_health_set(new_value: int) -> void:
	health = clampi(new_value, 0, current_max_health)
	health_changed.emit(health, current_max_health)
	if health <= 0:
		health_depleted.emit()

func _on_poisehp_set(new_value: int) -> void:
	poisehp = clampi(new_value, 0, current_max_poisehp)
	poisehp_changed.emit(poisehp, current_max_poisehp)
	if poisehp <= 0:
		poisehp_depleted.emit()

func _on_armor_set(new_value: int) -> void:
	armor = clampi(new_value, 0, current_max_armor)
	armor_changed.emit(armor, current_max_armor)
	if armor <= 0:
		armor_broken.emit()

func _on_rumstack_set(new_value: int) -> void:
	var old_rum_stacks: int = rum_stacks
	var was_depleted: bool = old_rum_stacks < 0
	var was_sober: bool = old_rum_stacks < rum_tipsy_threshold
	var was_tipsy: bool = old_rum_stacks < rum_drunk_threshold and old_rum_stacks >= rum_tipsy_threshold
	var was_drunk: bool = old_rum_stacks >= rum_drunk_threshold

	rum_stacks = maxi(0, new_value)
	var is_depleted: bool = rum_stacks < 0
	var is_sober: bool = rum_stacks < rum_tipsy_threshold
	var is_tipsy: bool = rum_stacks >= rum_tipsy_threshold and rum_stacks < rum_drunk_threshold
	var is_drunk: bool = rum_stacks >= rum_drunk_threshold

	if !was_depleted and is_depleted:
		rumstacks_depleted.emit()
	if !was_sober and is_sober:
		drunk_state_changed.emit(DrunkStates.SOBER)
		rum_sober.emit()
	if !was_tipsy and is_tipsy:
		drunk_state_changed.emit(DrunkStates.TIPSY)
		rum_tipsy.emit()
	if !was_drunk and is_drunk:
		drunk_state_changed.emit(DrunkStates.DRUNK)
		rum_drunk.emit()
