extends Node

# componnets
@onready var handle_spare_symbols : Node = $".."
@onready var handle_spare_smybols_effects : Node = $"../SpareSymbolEffects"
@onready var profiler_audio_manager : Node3D = $"../../../../ProfilerAudioManager"



func _handle_value_changed(selected_stat : String, new_value : float, old_value : float) :
	
	var selected_stat_selected_icons : Dictionary = handle_spare_symbols.selected_stat_selected_icons 
	
	# get start and stop value
	# note : we ignore if none
	
	var selected_icon 
	
	match selected_stat :
		'strength' :
			selected_icon = selected_stat_selected_icons['strength']
		'intelligence' :
			selected_icon = selected_stat_selected_icons['intelligence']
		'community' :
			selected_icon = selected_stat_selected_icons['community']
	
	if selected_icon['type'] == 'none' :
		return

	var min_range_num = selected_icon['start']
	var max_range_num = selected_icon['stop']
	var new_value_in_range = evaluate_num_in_range(new_value, min_range_num, max_range_num )
	var old_value_in_range = evaluate_num_in_range(old_value, min_range_num, max_range_num )
	
	if new_value_in_range == old_value_in_range : 
		return
	
	# entere area
	elif new_value_in_range and not old_value_in_range :
		profiler_audio_manager.play_spare_enter()
		GLPrisonerProfilerComponentsBus.emit_signal('station_feedback_requested', 'spare_label', {'data' : selected_icon})
		GLPrisonerProfilerComponentsBus.emit_signal("station_feedback_requested", "spare_icon", { "data": { "icon_type": selected_icon["type"], "stat_type": selected_stat}})		
		handle_spare_smybols_effects._activate(true, selected_icon)
		
	# exit area
	elif old_value_in_range and not new_value_in_range: 
		profiler_audio_manager.play_spare_exit()
		handle_spare_smybols_effects._activate(false, selected_icon)
	
	
func evaluate_num_in_range(num : float, min_num : float, max_num : float) -> bool :
	if num >= min_num and num <= max_num :
		return true
	else :
		return false

	
		
		
	
	
	
	
