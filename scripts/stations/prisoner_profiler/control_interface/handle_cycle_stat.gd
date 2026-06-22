extends Node

@onready var parent_profiler : Node3D = $"../.."

func _stat_cycle_btn_down(direction : String) :
	
	var index_direction : int 
	
	match direction :
		'up' :
			index_direction = 1
		'down' :
			index_direction = -1
		_ : 
			push_error('invalid direction : ', direction)
	
	var stats = ['strength', 'intelligence', 'community']	
	
	var current_selected_stat = parent_profiler.selected_stat
	var current_index : int = 0
	
	# if no selected stat already
	if not len(current_selected_stat) > 1 :	
		if direction == 'up' :
			current_index = 0			
		
	# if stat selected already
	else :	
		current_index = selected_stat_to_index(stats, current_selected_stat)
	
	# increment current index with direction
	current_index += index_direction	
	
	# if invalid index in array
	if current_index >= 0 and current_index < stats.size():
		parent_profiler.selected_stat = ''
	else :
		parent_profiler.selected_stat = stats[current_index]
	
	
	
	
func selected_stat_to_index(stats : Array[String], current_selected_stat : String) -> int :
	var index = stats.find(current_selected_stat)
	if index == -1 :
		push_error('no stat index : ', stats, ' found corrisponding with : ', current_selected_stat)
	return index



	
	
	
	
	
	
	
	
	
	
	
	
	
