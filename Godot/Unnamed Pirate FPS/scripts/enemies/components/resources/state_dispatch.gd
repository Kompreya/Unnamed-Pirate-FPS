extends Resource
class_name NPCStateDispatch

enum StateChangeOptions {
	IMMEDIATE,
	REQUEST,
}

## Higher number is higher priority
@export_range(0, 10, 1) var priority: int
@export_node_path("State") var dispatch_state: NodePath
@export var state_change_type: StateChangeOptions = StateChangeOptions.REQUEST
