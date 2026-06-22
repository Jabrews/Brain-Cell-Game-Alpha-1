extends Node

# componnetso
@onready var parent_station : Node3D = $"../.."



func _handle_increment_btn_down(increment_direction : String):
	
	if parent_station.selected_stat == '' :
		return
	
	
	var direction : int = 0	
	
	if increment_direction == 'up' :
		direction = 1
	else :
		direction = -1
	
	var selected_stat_type = parent_station.selected_stat 
	var selected_stat_value = parent_station.stat_type_to_value(selected_stat_type)

	selected_stat_value += direction * IVPrisonerProfiler.stat_increment_amount
	
	parent_station._handle_stat_value_changed(selected_stat_type, selected_stat_value)


	
	
	
	
