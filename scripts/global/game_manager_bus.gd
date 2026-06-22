extends Node


var max_rounds = 4
var current_round = 3

var curr_energy : int = 100
var max_energy : int = 100


# called when prisoner is generated 
signal proceed_next_round()
signal proceed_next_energy_turn()

# when just the num changes
signal energy_changed()

# after round fade to black
signal reset_player_position()
