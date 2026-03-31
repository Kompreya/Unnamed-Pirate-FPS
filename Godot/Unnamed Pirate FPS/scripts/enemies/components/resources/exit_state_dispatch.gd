extends Resource
class_name NPCExitStateDispatch

enum StateChangeOptions {
	IMMEDIATE,
	REQUEST,
}

@export_node_path("State") var exit_state: NodePath
@export var state_change_type: StateChangeOptions = StateChangeOptions.REQUEST
