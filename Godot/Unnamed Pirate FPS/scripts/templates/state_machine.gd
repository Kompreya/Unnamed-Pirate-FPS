extends Node
class_name StateMachine

signal enter(new_state: State)
signal exit(current_state: State)

var states: Dictionary = {}
var current_state: State
@export var initial_state: State

func _ready() -> void:
	for child:Node in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.state_transition.connect(change_state)

	if initial_state:
		initial_state.Enter.call_deferred()
		current_state = initial_state

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)

func change_state(source_state: State, new_state_name: String) -> void:
	if source_state != current_state:
		prints("Invalid change_state trying from:" + source_state.name + "but currently in:" + current_state.name)
		return

	var new_state: State = states.get(new_state_name.to_lower())
	if !new_state:
		print("New state is empty")
		return

	if current_state:
		current_state.Exit()
		exit.emit(current_state)

	new_state.Enter()
	enter.emit(new_state)

	current_state = new_state

func request_state(requested_state: String) -> void:
	var new_state: State = states.get(requested_state.to_lower())

	if !new_state:
		print(str(new_state) + " does not exist in dictionary of " + str(self.get_script().get_global_name()))
		return

	if current_state == new_state:
		print(str(current_state) + " is already active in " + str(self.get_script().get_global_name()))
		return

	if current_state:
		var exit_callable: Callable = Callable(current_state, "Exit")
		exit_callable.call_deferred()

	new_state.Enter()

	current_state = new_state
