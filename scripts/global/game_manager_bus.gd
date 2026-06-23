extends Node


var max_rounds = 4
var current_round = 3

var curr_energy : int = 100
var max_energy : int = 100


# called when target comp. finishes
signal proceed_next_round()
# called after incremental values changes
signal proceed_next_energy_turn()
signal process_next_round()

# when just the energy num changes without full updating
signal energy_changed()

# after round fade to black
signal reset_player_position()
