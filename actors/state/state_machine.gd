class_name StateMachine
extends RefCounted

var state: State

func _init(init_state: State = null):
    state = init_state

func change_state(new_state: State, force = false):
    if new_state == state and not force:
        return
    if state:
        state.exit()
    new_state.enter()
    state = new_state

func update(delta):
    if state:
        state.update(delta)
