@icon("res://addons/plenticons/icons/16x/2d/double-chevron-right-green.png")

extends Node3D
class_name EnemyMoveComponent

#state machines
@export var state_machines: Array[StateMachine]

@export var move_state_conditions: Array[NPCStateConditions]

@export var state_component: EnemyStateComponent
@export var enemy_stats: EnemyStats
@export var path_component: EnemyPathComponent
@export var anim_tree: AnimationTree
@export var parent: CharacterBody3D

var entity_speed: float

var current_enter_states: Array[PendingEnterState]
var pending_enter_states: Array[PendingEnterState]

var current_exit_state: State

@export var can_move: bool = true:
	set(value):
		can_move = value

func _ready() -> void:
	if state_machines:
		for sm:StateMachine in state_machines:
			#sm.enter.connect(state_machine_transitions.bind("entered"))
			sm.enter.connect(dispatch_enter_states)
			#sm.exit.connect(state_machine_transitions.bind("exited"))

func _process(_delta: float) -> void:
	parent.velocity = (path_component.next_nav_point - parent.global_transform.origin).normalized() * entity_speed
	parent.move_and_slide()

func dispatch_enter_states(state: State) -> void:
	for c:NPCStateConditions in move_state_conditions:
		var state_node: State = get_node(c.received_state)
		if state_node == state:
			for d:NPCDispatchStates in c.dispatch_states:
				var p: PendingEnterState = PendingEnterState.new()
				p.state_machine = get_node(d.state_machine)
				p.state = get_node(d.enter_state_dispatch.enter_state)
				p.priority = d.enter_state_dispatch.priority
				p.state_change_type = d.enter_state_dispatch.state_change_type
				set_current_enter_state(p)

func set_current_enter_state(new_pend: PendingEnterState) -> void:
	if current_enter_states.is_empty():
		current_enter_states.append(new_pend)
		dispatch_state(new_pend)
	elif !current_enter_states.is_empty():
		for c:PendingEnterState in current_enter_states:
			if new_pend.state_machine.get_class() == c.state_machine.get_class():
				if new_pend.priority > c.priority:
					var c_idx: int = current_enter_states.bsearch(c)
					current_enter_states.set(c_idx, new_pend)
					dispatch_state(new_pend)
				elif new_pend.priority <= c.priority:
					set_pending_enter_state(c)

func set_pending_enter_state(new_pend: PendingEnterState) -> void:
	if pending_enter_states.is_empty():
		pending_enter_states.append(new_pend)
	elif !pending_enter_states.is_empty():
		for c:PendingEnterState in pending_enter_states:
			if new_pend.state_machine.get_class() == c.state_machine.get_class():
				if new_pend.priority > c.priority:
					var c_idx: int = pending_enter_states.bsearch(c)
					pending_enter_states.set(c_idx, new_pend)

func dispatch_state(dispatch: PendingEnterState) -> void:
	match dispatch.state_change_type:
		NPCEnterStateDispatch.StateChangeOptions.IMMEDIATE:
			dispatch.state_machine.change_state(dispatch.state.name)
		NPCEnterStateDispatch.StateChangeOptions.REQUEST:
			dispatch.state_machine.request_state(dispatch.state.name)



# PLAN TO REPLACE WITH PRIORITY QUEUE
func state_machine_transitions(state: State, transition: String) -> void:
	match transition:
		"entered":
			for c:NPCStateConditions in move_state_conditions:
				var state_node: State = get_node(c.received_state)
				if state_node == state:
					for d:NPCDispatchStates in c.dispatch_states:
						var sm: StateMachine = get_node(d.state_machine)
						var enter: State = get_node(d.enter_state_dispatch.enter_state)
						match d.enter_state_dispatch.state_change_type:
							d.enter_state_dispatch.StateChangeOptions.IMMEDIATE:
								sm.change_state(enter.name.to_lower())
							d.enter_state_dispatch.StateChangeOptions.REQUEST:
								sm.request_state(enter.name.to_lower())
								print("Requesting " + str(enter) + " from move comp")

		"exited":
			for c:NPCStateConditions in move_state_conditions:
				var state_node: State = get_node(c.received_state)
				if state_node == state:
					for d:NPCDispatchStates in c.dispatch_states:
						var sm: StateMachine = get_node(d.state_machine)
						var exit: State = get_node(d.exit_state_dispatch.exit_state)
						match d.exit_state_dispatch.state_change_type:
							d.exit_state_dispatch.StateChangeOptions.IMMEDIATE:
								sm.change_state(exit.name.to_lower())
							d.exit_state_dispatch.StateChangeOptions.REQUEST:
								sm.request_state(exit.name.to_lower())
