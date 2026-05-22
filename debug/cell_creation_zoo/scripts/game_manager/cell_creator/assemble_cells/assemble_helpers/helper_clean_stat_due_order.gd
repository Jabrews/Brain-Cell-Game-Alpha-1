extends Node

func _verify_user_clean_stat_due_order(constructors: Array[CellConstructor]) :
	
	# prevent when the option isnt turned on
	if not GLToggleCleanStatDueOrder.check_for_clean_stat_due_order:
		return constructors
	

	# target stats for later comparison
	var target_strength = GLCellManagerBus.target_cell_refrence.strength		
	var target_intelligence = GLCellManagerBus.target_cell_refrence.intelligence
	var target_community = GLCellManagerBus.target_cell_refrence.community
	
	var target_stat_objects = [
		{'stat_type': 'strength', 'value': target_strength},
		{'stat_type': 'intelligence', 'value': target_intelligence},
		{'stat_type': 'community', 'value': target_community},
	]	
	
	var verified_constructors : Array[CellConstructor] = []
	
	for constructor : CellConstructor in constructors:
		
		# for early clean range cases dont worry about it
		# this includes : low, lowest, medium-low
		var clean_range : String = constructor.clean_ranges 
		
		if clean_range == 'low' \
		or clean_range == 'lowest' \
		or clean_range == 'medium-low':
			
			verified_constructors.append(constructor)
			continue
		
		# otherwise its above medium-low and must verify
		var strength_clean_min : float = 0.0			
		var intelligence_clean_min : float = 0.0			
		var community_clean_min : float = 0.0			
			
		# update target stat minimums depending on clean range
		for target_stat_object in target_stat_objects:
			
			var stat_clean_min : float = 0.0
			
			var round_1_max_value = 160
			# measures how much stronger the current round cap is
			# compared to the original round 1 balancing target
			var difference_from_round_1_max = (IVCellCreator.max_stat_value - round_1_max_value) * .2
			
			match clean_range:
				'medium':
					stat_clean_min = target_stat_object['value'] * .30
					stat_clean_min -= difference_from_round_1_max 
				'medium-elevated':
					stat_clean_min = target_stat_object['value'] * .40
					stat_clean_min -= difference_from_round_1_max 
				'high':
					stat_clean_min = target_stat_object['value'] * .60
					stat_clean_min -= difference_from_round_1_max 
				_:
					push_error('unable to find assembler clean range : ' + clean_range)
			
			match target_stat_object['stat_type']:
				'strength':
					strength_clean_min = stat_clean_min
				'intelligence':
					intelligence_clean_min = stat_clean_min
				'community':
					community_clean_min = stat_clean_min
				_:
					push_error(
						'unable to find stat on target_stat_obj : '
						+ str(target_stat_object['stat_type'])
					)
		
		# verify player has cells capable of supporting this constructor
		var collected_cells : Array[BrainCell] = GLCellManagerBus.collected_cells_refrence
		
		var has_strength := false
		var has_intelligence := false
		var has_community := false
		
		for cell : BrainCell in collected_cells:
			
			if cell.strength >= strength_clean_min:
				has_strength = true
			
			if cell.intelligence >= intelligence_clean_min:
				has_intelligence = true
			
			if cell.community >= community_clean_min:
				has_community = true
		
		if has_strength and has_intelligence and has_community:
			
			verified_constructors.append(constructor)
		
		# else we bring it one clean stat order down
		# EX. 'high' -> 'medium-elevated'
		else:
			
			var new_clean_range : String
			
			match constructor.clean_ranges:
				'medium':
					print(
						'clean stat due order. Old range : ',
						constructor.clean_ranges,
						' New range : medium-low'
					)
					new_clean_range = 'medium-low'
				
				'medium-elevated':
					print(
						'clean stat due order. Old range : ',
						constructor.clean_ranges,
						' New range : medium'
					)
					new_clean_range = 'medium'
				
				'high':
					print(
						'clean stat due order. Old range : ',
						constructor.clean_ranges,
						' New range : medium-elevated'
					)
					new_clean_range = 'medium-elevated'
				
				_:
					push_error(
						'unable to find FINALE assembler clean range : '
						+ clean_range
					)
			
			constructor.clean_ranges = new_clean_range
			verified_constructors.append(constructor)
	
	return verified_constructors
