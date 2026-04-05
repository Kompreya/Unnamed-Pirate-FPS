@icon("res://addons/plenticons/icons/16x/2d/double-chevron-right-green.png")

extends Node3D
class_name EnemyMoveComponent

@export var t: Animation

#state machines
@export var state_machines: Array[StateMachine]
@export var default_states: Array[DefaultStates]
@export var move_state_conditions: Array[NPCStateConditions]

@export var state_component: EnemyStateComponent
@export var enemy_stats: EnemyStats
@export var path_component: EnemyPathComponent
@export var anim_tree: AnimationTree
@export var parent: CharacterBody3D

var entity_speed: float

var current_states: Array[StateQueueTicket]
var pending_states: Array[StateQueueTicket]

func _ready() -> void:
	if state_machines:
		for sm:StateMachine in state_machines:
			sm.enter.connect(on_state_transition.bind("enter"))
			sm.exit.connect(on_state_transition.bind("exit"))

func _process(_delta: float) -> void:
	parent.velocity = (path_component.next_nav_point - parent.global_transform.origin).normalized() * entity_speed
	parent.move_and_slide()

func on_state_transition(state: State, transition: String) -> void:
	match transition:
		"enter":
			for c:NPCStateConditions in move_state_conditions:
				var state_node: State = get_node(c.received_state)
				if state_node == state:
					for d:NPCStateMachineDispatch in c.dispatch_states:
						if d.enter_state_dispatch:
							var enter_dispatch: NPCStateDispatch = d.enter_state_dispatch
							var ticket: StateQueueTicket = create_state_ticket(d, enter_dispatch)
							print("Created dispatch ticket for " + str(enter_dispatch.dispatch_state))
							print("Ticket number is " + str(ticket))
							set_current_state(ticket)
		"exit":
			for c:NPCStateConditions in move_state_conditions:
				var state_node: State = get_node(c.received_state)
				if state_node == state:
					for d:NPCStateMachineDispatch in c.dispatch_states:
						if d.exit_state_dispatch:
							var exit_dispatch: NPCStateDispatch = d.exit_state_dispatch
							var ticket: StateQueueTicket = create_state_ticket(d, exit_dispatch)
							set_current_state(ticket)
						elif !d.exit_state_dispatch:
							print("shifting queue for " + str(d.queue_ticket))
							clear_queue(d.queue_ticket)
							shift_queue()

func create_state_ticket(machine_dispatch: NPCStateMachineDispatch, state_dispatch: NPCStateDispatch) -> StateQueueTicket:
	var ticket:StateQueueTicket = StateQueueTicket.new()
	ticket.state_machine = get_node(machine_dispatch.state_machine)
	ticket.state = get_node(state_dispatch.dispatch_state)
	ticket.priority = state_dispatch.priority
	ticket.state_change_type = state_dispatch.state_change_type
	machine_dispatch.queue_ticket = ticket
	return ticket



func clear_queue(ticket: StateQueueTicket) -> void:
	var current_ticket: int = current_states.has(ticket)
	var pending_ticket: int = pending_states.has(ticket)
	print("result of current ticket " + str(ticket.state) + "is " + str(current_ticket))
	if current_ticket:
		print("current ticket found")
		current_states.erase(ticket)
	if pending_ticket:
		pending_states.erase(ticket)

func try_defaults() -> void:
	for d:DefaultStates in default_states:
		if current_states:
			var default_sm: StateMachine = get_node(d.state_machine)

			var found: bool = current_states.any(func(ticket: StateQueueTicket) -> bool:
				return ticket.state_machine == default_sm)
			if !found:
				dispatch_defaults(d)
		elif !current_states:

			dispatch_defaults(d)


func dispatch_defaults(default_state: DefaultStates) -> void:
	var sm: StateMachine = get_node(default_state.state_machine)
	var s: State = get_node(default_state.state)
	sm.request_state(s.name)
	print("SETTING DEFAULT STATE " + str(s) + " ON " + str(sm))

func shift_queue() -> void:
	if current_states.is_empty():

		if pending_states.is_empty():
			pass

		elif !pending_states.is_empty():
			print("current states empty, pending has states, shifting up and dispatching")
			current_states.assign(pending_states)
			pending_states.clear()
			for p:StateQueueTicket in current_states:
				dispatch_state(p)

	elif !current_states.is_empty():

		if !pending_states.is_empty():
			for p:StateQueueTicket in pending_states:
				for c:StateQueueTicket in current_states:
					if p.state_machine == c.state_machine:
						print(str(p.state_machine) + " " + str(c.state_machine))
						if p.priority > c.priority:
							print(str(p.state) + " found to have higher priority from pending, shifting to current")
							var c_idx: int = current_states.bsearch(c)
							current_states.set(c_idx, p)
							pending_states.erase(p)
							dispatch_state(p)
					elif !p.state_machine == c.state_machine:
						print(str(p.state) + " not present in current, shifting from pending to current")
						current_states.append(p)
						pending_states.erase(p)
						dispatch_state(p)
						break
	try_defaults()

func set_current_state(new_pend: StateQueueTicket) -> void:
	if current_states.is_empty():
		current_states.append(new_pend)
		dispatch_state(new_pend)
		print("Array empty, appending " + str(new_pend))
	elif !current_states.is_empty():
		for c:StateQueueTicket in current_states:
			if new_pend.state_machine == c.state_machine:
				print(str(new_pend.state_machine) + " " + str(c.state_machine))
				if new_pend.priority > c.priority:
					print("From set current state, " + str(new_pend.state) + "has HIGHER priority, dispatching")
					set_pending_state(c)
					var c_idx: int = current_states.bsearch(c)
					current_states.set(c_idx, new_pend)
					dispatch_state(new_pend)
				elif new_pend.priority <= c.priority:
					print("From set current state, " + str(new_pend.state) + "has LOWER priority, pending")
					set_pending_state(new_pend)
					break
			elif !new_pend.state_machine == c.state_machine:
				print("New ticket added for " + str(new_pend.state_machine) + "with " + str(new_pend.state))
				current_states.append(new_pend)
				dispatch_state(new_pend)
				break

func set_pending_state(new_pend: StateQueueTicket) -> void:
	if pending_states.is_empty():
		pending_states.append(new_pend)
	elif !pending_states.is_empty():
		for c:StateQueueTicket in pending_states:
			if new_pend.state_machine == c.state_machine:
				if new_pend.priority > c.priority:
					var c_idx: int = pending_states.bsearch(c)
					pending_states.set(c_idx, new_pend)

func dispatch_state(dispatch: StateQueueTicket) -> void:
	print("DISPATCHING STATE " + str(dispatch.state) + " ON " + str(dispatch.state_machine))
	match dispatch.state_change_type:
		NPCStateDispatch.StateChangeOptions.IMMEDIATE:
			dispatch.state_machine.change_state(dispatch.state.name)
		NPCStateDispatch.StateChangeOptions.REQUEST:
			dispatch.state_machine.request_state(dispatch.state.name)
