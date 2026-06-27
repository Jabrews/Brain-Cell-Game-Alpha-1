extends Node

# componnets
@onready var handle_spare_symbols : Node = $".."
@onready var handle_spare_symbols_effects : Node = $"../SpareSymbolEffects"
@onready var profiler_audio_manager : Node3D = $"../../../../ProfilerAudioManager"



func _handle_value_changed(selected_stat : String, new_value : float, old_value : float) :
	
	var spare_icon_constructors : Array[SpareIconConstuctor]= handle_spare_symbols.selected_spare_icon_constructors
	
	var selected_spare_icon_constructor : SpareIconConstuctor
	
	for spare_icon_constructor : SpareIconConstuctor in spare_icon_constructors :
		if spare_icon_constructor.stat == selected_stat :
			selected_spare_icon_constructor = spare_icon_constructor
	if not selected_spare_icon_constructor :
		push_error('unable to find spare icon contructor')
	
	if selected_spare_icon_constructor.type == 'none' :
		return

	var min_range_num = selected_spare_icon_constructor.start
	var max_range_num = selected_spare_icon_constructor.stop
	var new_value_in_range = evaluate_num_in_range(new_value, min_range_num, max_range_num )
	var old_value_in_range = evaluate_num_in_range(old_value, min_range_num, max_range_num )
	
	if new_value_in_range == old_value_in_range : 
		return
	
	# enter area
	elif new_value_in_range and not old_value_in_range :
		profiler_audio_manager.play_spare_enter()
		GLPrisonerProfilerComponentsBus.emit_signal('station_feedback_requested', 'spare_label', {'data' : selected_spare_icon_constructor})
		GLPrisonerProfilerComponentsBus.emit_signal("station_feedback_requested", "spare_icon", { "data": { 
			"icon_type": selected_spare_icon_constructor.type, 
			"stat_type": selected_spare_icon_constructor.stat
		}})		
		handle_spare_symbols_effects._activate(true, selected_spare_icon_constructor)
		
	# exit area
	elif old_value_in_range and not new_value_in_range: 
		profiler_audio_manager.play_spare_exit()
		handle_spare_symbols_effects._activate(false, selected_spare_icon_constructor)
	
	
func evaluate_num_in_range(num : float, min_num : float, max_num : float) -> bool :
	if num >= min_num and num <= max_num :
		return true
	else :
		return false

	
		
		
	
	
	
	
