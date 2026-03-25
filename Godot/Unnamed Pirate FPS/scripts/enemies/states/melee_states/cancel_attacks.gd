extends State
class_name NPCCancelMeleeAttacks

func Enter() -> void:
	print("cancelling melees")
	%StateComponent.attack_state = EnemyStateComponent.AttackStateList.NONE
	%StateComponent.attack_state = EnemyStateComponent.MeleeAttackList.NONE
