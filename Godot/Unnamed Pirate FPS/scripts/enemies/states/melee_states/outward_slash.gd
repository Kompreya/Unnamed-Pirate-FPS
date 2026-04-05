extends State
class_name NPCOutwardSlash

@export var state_component: EnemyStateComponent
@export var melee_state_machine: NPCMeleeStateMachine

@export var anim_tree: AnimationTree
@export var anim_player: AnimationPlayer

@onready var anim: Animation = anim_player.get_animation("animation_pack/attack")
@onready var anim_state: AnimationNodeStateMachinePlayback = anim_tree.get("parameters/ALIVE_STATE/playback")

const anim_attack_states: String = "MELEE_ATTACK_STATES"

func _ready() -> void:
	anim_state.state_finished.connect(_on_animstate_finished)

# virtual funcs
func enter() -> void:
	super()
	#print("Slashing!")
	_can_exit = false
	state_component.attack_state = EnemyStateComponent.AttackStateList.MELEE
	state_component.melee_attack = EnemyStateComponent.MeleeAttackList.OUTWARD_SLASH
	anim.loop_mode = (Animation.LOOP_LINEAR)

func exit() -> void:
	super()
	#print ("slash attack ending")

# state funcs
func cancel_attack() -> void:
	state_component.attack_state = EnemyStateComponent.AttackStateList.NONE
	state_component.melee_attack = EnemyStateComponent.MeleeAttackList.NONE
	anim.loop_mode = (Animation.LOOP_NONE)

func _on_animstate_finished(state_name: String) -> void:
	#print("anim state has finished!!" + state_name)
	if state_name == anim_attack_states:
		_can_exit = true
