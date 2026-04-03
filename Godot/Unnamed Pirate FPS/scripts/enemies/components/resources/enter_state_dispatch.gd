extends Resource
class_name NPCEnterStateDispatch

enum StateChangeOptions {
	IMMEDIATE,
	REQUEST,
}

## Higher number is higher priority
@export_range(0, 10, 1) var priority: int
@export_node_path("State") var enter_state: NodePath
@export var state_change_type: StateChangeOptions = StateChangeOptions.REQUEST
