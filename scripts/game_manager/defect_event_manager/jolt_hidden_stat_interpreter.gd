extends Node



func _handle_jolt() :
	
	# random num (1 - 100)
	var ran_num = randi_range(1, 100)
	
	var all_jolt_chance = IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt
	
	# all interpreters jolt
	if ran_num <= all_jolt_chance:
		
		GLDefectEventMangerBus.emit_signal(
			"event_hidden_stat_interpreter_jolt",
			["strength", "intelligence", "community"]
		)
		# emit sound
		GLPlayerLocalSoundsBus.emit_signal('sound_hidden_stat_interpreter_all_jolt')
	
	# single interpreter jolt
	else:
		decide_single_stat_interpreter()
	

func decide_single_stat_interpreter() -> void:
	
	var strength_chance = IVDefectEventManager.jolt_strength_chance
	var intelligence_chance = IVDefectEventManager.jolt_intelligence_chance
	var community_chance = IVDefectEventManager.jolt_community_chance
	
	# random num (0 - 100)
	var ran_num = randi_range(0, 100)
	
	# strength
	if ran_num <= strength_chance:
		GLDefectEventMangerBus.emit_signal(
			"event_hidden_stat_interpreter_jolt",
			["strength"]
		)
	
	# intelligence
	elif ran_num <= intelligence_chance:
		GLDefectEventMangerBus.emit_signal(
			"event_hidden_stat_interpreter_jolt",
			["intelligence"]
		)
	
	# community
	elif ran_num <= community_chance:
		GLDefectEventMangerBus.emit_signal(
			"event_hidden_stat_interpreter_jolt",
			["community"]
		)
