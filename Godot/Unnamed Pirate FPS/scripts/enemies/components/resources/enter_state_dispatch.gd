extends Resource
class_name NPCEnterStateDispatch

enum StateChangeOptions {
	IMMEDIATE,
	REQUEST,
}

@export_node_path("State") var enter_state: NodePath
@export var state_change_type: StateChangeOptions = StateChangeOptions.REQUEST
