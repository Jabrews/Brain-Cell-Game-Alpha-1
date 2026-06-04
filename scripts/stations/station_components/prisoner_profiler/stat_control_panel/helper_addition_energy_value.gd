extends Node

var current_value = 0

func _handle_get_energy_add_value(direction : String) -> int:
	if direction == 'up' :
		current_value += 1
	if direction == 'down' :
		current_value += -1
	
	return current_value
	
