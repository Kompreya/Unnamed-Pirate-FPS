extends State
class_name NPCCancelMeleeAttacks

@export var state_component: EnemyStateComponent

func enter() -> void:
	super()
	if state_component:
		print("cancelling melees")
		state_component.attack_state = EnemyStateComponent.AttackStateList.NONE
		state_component.melee_attack = EnemyStateComponent.MeleeAttackList.NONE
