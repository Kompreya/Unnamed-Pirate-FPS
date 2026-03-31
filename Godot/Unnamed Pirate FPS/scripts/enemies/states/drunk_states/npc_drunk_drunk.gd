extends State
class_name NPCDrunkDrunk

@export var state_component: EnemyStateComponent
@export var status_component: EnemyStatusComponent

# virtual funcs
func enter() -> void:
	super()
	if state_component:
		state_component.drunk_status = EnemyStateComponent.DrunkStatusList.DRUNK

func update(delta: float) -> void:
	if status_component:
		status_component.elapse_rum_timer(delta)
