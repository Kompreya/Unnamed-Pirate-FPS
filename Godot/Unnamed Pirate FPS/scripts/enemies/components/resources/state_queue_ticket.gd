extends Resource
class_name StateQueueTicket

var state_machine: StateMachine
var state: State
var priority: int
var state_change_type: NPCStateDispatch.StateChangeOptions
