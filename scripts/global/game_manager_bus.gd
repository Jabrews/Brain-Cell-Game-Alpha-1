extends Node


var max_rounds = 4
var current_round = 2

var max_turns = 4
var current_turn = 0

# conneted
signal attempt_next_turn()
signal proceed_next_round()

# emitted
signal finale_turn()
signal finale_turn_ended_new_round_proceed()
signal next_turn_process()
