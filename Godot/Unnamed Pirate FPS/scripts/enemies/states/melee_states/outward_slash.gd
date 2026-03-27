extends State
class_name NPCOutwardSlash

@export var anim_tree: AnimationTree
@onready var anim: Animation = %AnimationPlayer.get_animation("animation_pack/attack")
@onready var anim_state: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/ALIVE_STATE/playback")

const anim_attack_states: String = "MELEE_ATTACK_STATES"

func _ready() -> void:
	anim_state.state_finished.connect(_on_animstate_finished)

func Enter() -> void:
	print("Slashing!")
	_can_exit = false
	%StateComponent.attack_state = EnemyStateComponent.AttackStateList.MELEE
	%StateComponent.melee_attack = EnemyStateComponent.MeleeAttackList.OUTWARD_SLASH
	anim.loop_mode = (Animation.LOOP_LINEAR)

func Exit() -> void:
	print ("slash attack ending")
	%MeleeStateMachine.exit.emit(self)

func Update(_delta: float) -> void:
	pass

func cancel_attack() -> void:
	%StateComponent.attack_state = EnemyStateComponent.AttackStateList.NONE
	%StateComponent.attack_state = EnemyStateComponent.MeleeAttackList.NONE
	anim.loop_mode = (Animation.LOOP_NONE)

func _on_animstate_finished(state_name: String) -> void:
	print("anim state has finished!!" + state_name)
	if state_name == anim_attack_states:
		_can_exit = true
