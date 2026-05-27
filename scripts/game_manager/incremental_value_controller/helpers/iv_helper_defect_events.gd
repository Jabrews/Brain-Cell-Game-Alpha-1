extends Node

@warning_ignore("shadowed_global_identifier")
func update_defect_event_values(round : int , turn : int) :
	
	# on turn 0 never have defect event occur
	if turn == 0 :	
		# jolt type events chance
		IVDefectEventManager.no_event_chance = 98
		IVDefectEventManager.jolt_cell_container_chance = 1
		IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 1
		# all interpreter
		IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt  = 1
		# jolt increase
		IVDefectEventManager.interpreter_jolt_defect_increase = 20
		IVDefectEventManager.cell_container_jolt_defect_increase = 20

	
	if round == 1 :
		IVDefectEventManager.stats_to_hide = []
		
		match turn :		
			1 :
				# jolt type events chance
				IVDefectEventManager.no_event_chance = 98
				IVDefectEventManager.jolt_cell_container_chance = 1
				IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 1
				# all interpreter
				IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt  = 1
				# jolt increase
				IVDefectEventManager.interpreter_jolt_defect_increase = 20
				IVDefectEventManager.cell_container_jolt_defect_increase = 20
			2 :
				# jolt type events chance
				IVDefectEventManager.no_event_chance = 98
				IVDefectEventManager.jolt_cell_container_chance = 1
				IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 1
				# all interpreter
				IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt  = 1
				# jolt increase
				IVDefectEventManager.interpreter_jolt_defect_increase = 20
				IVDefectEventManager.cell_container_jolt_defect_increase = 20
			3 :
				# jolt type events chance
				IVDefectEventManager.no_event_chance = 80
				IVDefectEventManager.jolt_cell_container_chance = 19
				IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 1
				# all interpreter
				IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt  = 1
				# jolt increase
				IVDefectEventManager.interpreter_jolt_defect_increase = 20
				IVDefectEventManager.cell_container_jolt_defect_increase = 20

			4 : 
				# jolt type events chance
				IVDefectEventManager.no_event_chance = 70
				IVDefectEventManager.jolt_cell_container_chance = 29
				IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 1
				# all interpreter
				IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt  = 1
				# jolt increase
				IVDefectEventManager.interpreter_jolt_defect_increase = 20
				IVDefectEventManager.cell_container_jolt_defect_increase = 20
	
	elif round == 2 :
		IVDefectEventManager.stats_to_hide = ['strength']
		
		match turn :		
			1 :
				# jolt type events chance
				IVDefectEventManager.no_event_chance = 98
				IVDefectEventManager.jolt_cell_container_chance = 1
				IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 1
				# all interpreter
				IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt  = 1
				# jolt increase
				IVDefectEventManager.interpreter_jolt_defect_increase = 20
				IVDefectEventManager.cell_container_jolt_defect_increase = 20
			2 :
				# jolt type events chance
				IVDefectEventManager.no_event_chance = 80
				IVDefectEventManager.jolt_cell_container_chance = 19
				IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 1
				# all interpreter
				IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt  = 1
				# jolt increase
				IVDefectEventManager.interpreter_jolt_defect_increase = 20
				IVDefectEventManager.cell_container_jolt_defect_increase = 20
			3 :
				# jolt type events chance
				IVDefectEventManager.no_event_chance = 70
				IVDefectEventManager.jolt_cell_container_chance = 1
				IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 29
				# all interpreter
				IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt  = 10
				# jolt increase
				IVDefectEventManager.interpreter_jolt_defect_increase = 25
				IVDefectEventManager.cell_container_jolt_defect_increase = 25

			4 : 
				# jolt type events chance
				IVDefectEventManager.no_event_chance = 50
				IVDefectEventManager.jolt_cell_container_chance = 20
				IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 30
				# all interpreter
				IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt  = 15
				# jolt increase
				IVDefectEventManager.interpreter_jolt_defect_increase = 30
				IVDefectEventManager.cell_container_jolt_defect_increase = 30
	
	
	elif round == 3 :
		IVDefectEventManager.stats_to_hide = ['strength', 'intelligence']
		
		match turn :		
			1 :
				# jolt type events chance
				IVDefectEventManager.no_event_chance = 98
				IVDefectEventManager.jolt_cell_container_chance = 1
				IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 1
				# all interpreter
				IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt  = 1
				# jolt increase
				IVDefectEventManager.interpreter_jolt_defect_increase = 20
				IVDefectEventManager.cell_container_jolt_defect_increase = 20
			2 :
				# jolt type events chance
				IVDefectEventManager.no_event_chance = 75
				IVDefectEventManager.jolt_cell_container_chance = 10
				IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 15
				# all interpreter
				IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt  = 15
				# jolt increase
				IVDefectEventManager.interpreter_jolt_defect_increase = 20
				IVDefectEventManager.cell_container_jolt_defect_increase = 20
			3 :
				# jolt type events chance
				IVDefectEventManager.no_event_chance = 75
				IVDefectEventManager.jolt_cell_container_chance = 10
				IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 15
				# all interpreter
				IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt  = 20
				# jolt increase
				IVDefectEventManager.interpreter_jolt_defect_increase = 20
				IVDefectEventManager.cell_container_jolt_defect_increase = 20

			4 : 
				# jolt type events chance
				IVDefectEventManager.no_event_chance = 70
				IVDefectEventManager.jolt_cell_container_chance = 15
				IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 15
				# all interpreter
				IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt  = 20
				# jolt increase
				IVDefectEventManager.interpreter_jolt_defect_increase = 25
				IVDefectEventManager.cell_container_jolt_defect_increase = 25
			5 : 
				# jolt type events chance
				IVDefectEventManager.no_event_chance = 65
				IVDefectEventManager.jolt_cell_container_chance = 15
				IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 20
				# all interpreter
				IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt  = 25
				# jolt increase
				IVDefectEventManager.interpreter_jolt_defect_increase = 30
				IVDefectEventManager.cell_container_jolt_defect_increase = 30
	
	
	elif round == 4 : 
		IVDefectEventManager.stats_to_hide = ['strength', 'intelligence', 'community']	
		
		match turn :		
			1 :
				# jolt type events chance
				IVDefectEventManager.no_event_chance = 98
				IVDefectEventManager.jolt_cell_container_chance = 1
				IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 1
				# all interpreter
				IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt  = 0
				# jolt increase
				IVDefectEventManager.interpreter_jolt_defect_increase = 10
				IVDefectEventManager.cell_container_jolt_defect_increase = 10
			2 :
				# jolt type events chance
				IVDefectEventManager.no_event_chance = 80
				IVDefectEventManager.jolt_cell_container_chance = 1
				IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 19
				# all interpreter
				IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt  = 1
				# jolt increase
				IVDefectEventManager.interpreter_jolt_defect_increase = 15
				IVDefectEventManager.cell_container_jolt_defect_increase = 15
			3 :
				# jolt type events chance
				IVDefectEventManager.no_event_chance = 70
				IVDefectEventManager.jolt_cell_container_chance = 15
				IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 15
				# all interpreter
				IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt  = 25
				# jolt increase
				IVDefectEventManager.interpreter_jolt_defect_increase = 25
				IVDefectEventManager.cell_container_jolt_defect_increase = 25

			4 : 
				# jolt type events chance
				IVDefectEventManager.no_event_chance = 60
				IVDefectEventManager.jolt_cell_container_chance = 20
				IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 20
				# all interpreter
				IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt  = 30
				# jolt increase
				IVDefectEventManager.interpreter_jolt_defect_increase = 30
				IVDefectEventManager.cell_container_jolt_defect_increase = 35
			5 : 
				# jolt type events chance
				IVDefectEventManager.no_event_chance = 50
				IVDefectEventManager.jolt_cell_container_chance = 30
				IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 20
				# all interpreter
				IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt  = 35
				# jolt increase
				IVDefectEventManager.interpreter_jolt_defect_increase = 35
				IVDefectEventManager.cell_container_jolt_defect_increase = 35
		
		
	
	
	
	
