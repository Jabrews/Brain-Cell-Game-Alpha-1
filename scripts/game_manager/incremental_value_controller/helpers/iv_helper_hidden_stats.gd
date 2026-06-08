extends Node

@warning_ignore("shadowed_global_identifier")
func _update_hidden_stat_values(round : int , energy : int) :
	
	
	if round == 1 :	
		IVHiddenStats.stats_to_hide = []
	
	elif round == 2 :
		IVHiddenStats.stats_to_hide = ['strength']
	
	elif round == 3 :
		IVHiddenStats.stats_to_hide = ['strength', 'intelligence']
	
	elif round == 4 : 
		IVHiddenStats.stats_to_hide = ['strength', 'intelligence', 'community']
	
	var danger_level = get_energy_danger_level(energy)		
	update_hidden_stat_nax(round, danger_level)
		

func get_energy_danger_level(energy : int) -> int:
	# high energy = safer
	# low energy = more dangerous
	
	var max_energy = GLGameManagerBus.max_energy

	if energy > max_energy * 0.75:
		return 0
	elif energy > max_energy * 0.5:
		return 1
	elif energy > max_energy * .25:
		return 2
	else:
		return 3
	
@warning_ignore("shadowed_global_identifier")
func update_hidden_stat_nax(round : int, danger_level : int) :
	
	if round == 1 :	
		match danger_level :
			0 : 
				IVHiddenStats.max_stats_to_hide = 0
			1 : 
				IVHiddenStats.max_stats_to_hide = 0
			2 : 
				IVHiddenStats.max_stats_to_hide = 0
			3 : 
				IVHiddenStats.max_stats_to_hide = 0
	
	elif round == 2 :
		match danger_level :
			0 : 
				IVHiddenStats.max_stats_to_hide = 1
			1 : 
				IVHiddenStats.max_stats_to_hide = 2
			2 : 
				IVHiddenStats.max_stats_to_hide = 3
			3 : 
				IVHiddenStats.max_stats_to_hide = 4
	
	elif round == 3 : 	
		match danger_level :
			0 : 
				IVHiddenStats.max_stats_to_hide = 3
			1 : 
				IVHiddenStats.max_stats_to_hide = 4
			2 : 
				IVHiddenStats.max_stats_to_hide = 5
			3 : 
				IVHiddenStats.max_stats_to_hide = 6
	
	elif round == 4 :
		match danger_level :
			0 : 
				IVHiddenStats.max_stats_to_hide = 5
			1 : 
				IVHiddenStats.max_stats_to_hide = 6
			2 : 
				IVHiddenStats.max_stats_to_hide = 7
			3 : 
				IVHiddenStats.max_stats_to_hide = 8
	
	
	
	
	
	
	
