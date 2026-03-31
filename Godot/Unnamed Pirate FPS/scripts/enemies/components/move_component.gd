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

@export var can_move: bool = true:
	set(value):
		can_move = value

func _ready() -> void:
	#SignalBus.drunk_status_changed.connect(_change_move_state)
	if state_machines:
		for sm:StateMachine in state_machines:
			sm.enter.connect(state_machine_transitions.bind("entered"))
			sm.exit.connect(state_machine_transitions.bind("exited"))

func _process(_delta: float) -> void:
	parent.velocity = (path_component.next_nav_point - parent.global_transform.origin).normalized() * entity_speed
	parent.move_and_slide()

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

#func _change_move_state(drunk_status: EnemyStateComponent.DrunkStatusList) -> void:
	#match drunk_status:
		#EnemyStateComponent.DrunkStatusList.SOBER:
			#state_component.move_state = EnemyStateComponent.MoveStateList.WALK
		#EnemyStateComponent.DrunkStatusList.TIPSY:
			#state_component.move_state = EnemyStateComponent.MoveStateList.SLOW_WALK
		#EnemyStateComponent.DrunkStatusList.DRUNK:
			#state_component.move_state = EnemyStateComponent.MoveStateList.SLOW_WALK
