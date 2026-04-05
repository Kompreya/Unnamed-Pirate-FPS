extends Resource
class_name NPCStateMachineDispatch

@export_node_path("StateMachine") var state_machine: NodePath
@export var enter_state_dispatch: NPCStateDispatch
@export var exit_state_dispatch: NPCStateDispatch

var queue_ticket: StateQueueTicket
