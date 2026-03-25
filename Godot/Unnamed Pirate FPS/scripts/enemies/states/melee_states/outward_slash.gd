extends State
class_name NPCOutwardSlash

@onready var anim: Animation = %AnimationPlayer.get_animation("animation_pack/attack")

func Enter() -> void:
	print("Slashing!")
	%SpeedStateMachine.request_state("at_rest")
	%StateComponent.attack_state = EnemyStateComponent.AttackStateList.MELEE
	%StateComponent.melee_attack = EnemyStateComponent.MeleeAttackList.OUTWARD_SLASH
	anim.loop_mode = (Animation.LOOP_LINEAR)

func Exit() -> void:
	%SpeedStateMachine.request_state("normal")
	anim.loop_mode = (Animation.LOOP_NONE)

func Update(_delta: float) -> void:
	pass
