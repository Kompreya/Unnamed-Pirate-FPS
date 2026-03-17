extends Resource
class_name EnemyBuff

enum BuffType{
	MULTIPLY,
	ADD,
}

@export var stat: EnemyStats.BuffableStats
@export var buff_amount: float
@export var buff_type: BuffType

func _init(_stat: EnemyStats.BuffableStats = EnemyStats.BuffableStats.MAX_HEALTH, _buff_amount: float = 1.0,
		_buff_type: EnemyBuff.BuffType = BuffType.MULTIPLY) -> void:
	stat = _stat
	buff_type = _buff_type
	buff_amount = _buff_amount
