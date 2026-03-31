extends State
class_name NPCDrunkTipsy

@export var state_component: EnemyStateComponent
@export var status_component: EnemyStatusComponent

# virtual funcs
func enter() -> void:
	super()
	if state_component:
		state_component.drunk_status = EnemyStateComponent.DrunkStatusList.TIPSY


func update(delta: float) -> void:
	if status_component:
		status_component.elapse_rum_timer(delta)
