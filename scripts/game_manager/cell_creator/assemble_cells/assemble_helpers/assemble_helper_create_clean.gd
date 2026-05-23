extends Node

func _create(clean_range : String) -> Array[float]:
	
	var target_cell : BrainCell = GLCellManagerBus.target_cell_refrence
	
	# note : this only happens on first turn
	if not target_cell :
		target_cell = BrainCell.new(
			'placeholder-target-cell',
			100,
			100,
			100,
			300,
			0,			
			0,			
			0,
		)	
	
	
	
	
	var str_clean = create_stat(target_cell.strength, clean_range)
	var int_clean = create_stat(target_cell.intelligence, clean_range)
	var com_clean = create_stat(target_cell.community, clean_range)
	var clean_stats : Array[float] = [
		str_clean,
		int_clean,
		com_clean
	]
	
	return clean_stats
	


func create_stat(target_stat : float, clean_range : String) -> float:

	var random_diffrence = randi_range(0, 30)
	
	var clean_stat : float
	

	# round 1 balancing baseline:
	# early rounds were designed around a target stat cap of 160.
	# as max target stats increase in later rounds,
	# clean stat generation must scale relative to that original balance point
	# instead of relying purely on flat percentages.
	var round_1_max_value = 160
	# measures how much stronger the current round cap is
	# compared to the original round 1 balancing target
	var difference_from_round_1_max = (IVCellCreator.max_stat_value - round_1_max_value) * .2
	
	
	if clean_range == 'lowest' : 	
		clean_stat = target_stat * .05
		clean_stat -= difference_from_round_1_max 
			
	elif clean_range == 'low':
		clean_stat = target_stat * .10
		clean_stat -= difference_from_round_1_max
	
	elif clean_range == 'medium-low' :
		clean_stat = target_stat * .20
		clean_stat -= difference_from_round_1_max 
		
	elif clean_range == 'medium':
		clean_stat = target_stat * .30
		clean_stat -= difference_from_round_1_max 
		
		
	elif clean_range == 'medium-elevated':
		clean_stat = target_stat * .40
		clean_stat -= difference_from_round_1_max 	
		
	elif clean_range == 'high':
		clean_stat = target_stat * .60
		clean_stat -= difference_from_round_1_max 	
	
	else :
		push_error("invalid clean range : ", clean_range )
	
	
	clean_stat += random_diffrence
	
	
	# round to 0.0 decimal
	clean_stat = round(clean_stat * 10.0) / 10.0

	return clean_stat
