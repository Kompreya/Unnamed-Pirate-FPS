extends State
class_name NPCDrunkSober

@export var state_component: EnemyStateComponent
@export var status_component: EnemyStatusComponent

# virtual funcs
func enter() -> void:
	super()
	if state_component:
		state_component.drunk_status = EnemyStateComponent.DrunkStatusList.SOBER


func update(delta: float) -> void:
	if status_component:
		status_component.elapse_rum_timer(delta)
