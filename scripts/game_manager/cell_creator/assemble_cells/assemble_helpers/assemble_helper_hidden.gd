extends Node

func _handle_hidden(constructor : CellConstructor, new_prisoners : Array[BrainCell]) :
	
	var stats_to_hide = IVHiddenStats.stats_to_hiint
	
	# exit early if no stats to hide
	if len(stats_to_hide) == 0 :
		return new_prisoners
	
	var max_stats_to_hide = IVHiddenStats.max_stats_to_hide
	
	# exit early if no stat hide quanity
	if max_stats_to_hide == 0 :
		return new_prisoners
	
	max_stats_to_hide = handle_reduce_quanity(constructor, max_stats_to_hide)
	
	
	
	
	
		

func handle_reduce_quanity(constructor : CellConstructor, max_stats_to_hide : int) :
	
	# if only two cells reduce by half
	if constructor.cell_quantity == 2:
		max_stats_to_hide = ceili(max_stats_to_hide / 2.0)
		# make sure this never goes below 1
		max_stats_to_hide = maxi(1, max_stats_to_hide)
	
	return max_stats_to_hide
			
			
		
	
	
	
