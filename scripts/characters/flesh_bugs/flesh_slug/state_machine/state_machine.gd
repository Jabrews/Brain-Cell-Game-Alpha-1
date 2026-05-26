extends Node

@onready var start_state : Node = $Start
@onready var follow_player_state : Node = $FollowPlayer
@onready var attack_state : Node = $Attack
@onready var dying_state : Node = $Dying

enum State {
	START,
	FOLLOW_PLAYER,
	ATTACK,
	DYING,
}

var states : Dictionary
var curr_state : Node


func _ready():

	states = {
		State.START: start_state,
		State.FOLLOW_PLAYER: follow_player_state,
		State.ATTACK: attack_state,	
		State.DYING: dying_state,		
	}

	switch_state(State.START)


func _process(delta):
	
	if curr_state and curr_state.has_method("state_process"):
		curr_state.state_process(delta)


func switch_state(new_state : State):

	# exit previous state
	if curr_state and curr_state.has_method("state_end"):
		curr_state.state_end()

	# set new state
	curr_state = states[new_state]

	# start new state
	if curr_state.has_method("state_start"):
		curr_state.state_start()

func get_current_state_name() -> String:
	for key in states:
		if states[key] == curr_state:
			return State.keys()[key].to_lower()
	
	return "unknown"
