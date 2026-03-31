extends State
class_name NPCDrunkDepleted

@export var state_component: EnemyStateComponent
@export var status_component: EnemyStatusComponent

# virtual funcs
func enter() -> void:
	super()
	if state_component:
		state_component.drunk_status = EnemyStateComponent.DrunkStatusList.DEPLETED
