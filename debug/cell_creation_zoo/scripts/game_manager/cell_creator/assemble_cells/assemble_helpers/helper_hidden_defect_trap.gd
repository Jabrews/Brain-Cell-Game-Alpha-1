extends Node


func _handle_hidden_stat_defect_trap_event(
	new_prisoners : Array[BrainCell],
	constructors : Array[CellConstructor]
) :
	
	var has_created_hidden_trap : bool = false
	
	for constructor : CellConstructor in constructors :
		
		# only allow 1 trap total for all constructors
		if has_created_hidden_trap :
			break
		
		var trap_created : bool = increase_hidden_stat_defect_event(
			new_prisoners,
			constructor
		)
		
		if trap_created :
			has_created_hidden_trap = true
	
	return new_prisoners



func increase_hidden_stat_defect_event(
	new_prisoners : Array[BrainCell],
	constructor : CellConstructor
) :
	
	# verify this round can have this event (last two rounds)
	var curr_round : int = GLGameManagerBus.current_round
	
	var event_valid : bool 
	
	match curr_round :
		3 :
			event_valid = true
		4 :
			event_valid = true
		_ :
			event_valid = false
	
	# if not valid round. return
	if not event_valid :
		return false
	
	# look at constructors StatsToHide to see if quantity is atleast 2
	for stat_to_hide : StatsToHide in constructor.stats_to_hide :
		
		if stat_to_hide.quantity > 1 :
			
			var hidden_stat_type = stat_to_hide.type
			
			var selected_trap_cell : BrainCell = find_hidden_trap_cell(
				new_prisoners,
				hidden_stat_type
			)
			
			# verify valid cell found
			if selected_trap_cell == null :
				continue
			
			print(
				'DEBUG : hidden trap planted. stat : ',
				hidden_stat_type,
				' cell : ',
				selected_trap_cell.name
			)
			
			var increase_defect_value = IVCellCreator.max_stat_value * .35
			
			# increase lowest defect by 50%
			match hidden_stat_type :
				
				
				'strength' :
					selected_trap_cell.strength_defect += increase_defect_value
				
				'intelligence' :
					selected_trap_cell.intelligence_defect += increase_defect_value
				
				'community' :
					selected_trap_cell.community_defect += increase_defect_value
			
			
			return true
	
	return false



func find_hidden_trap_cell(
	new_prisoners : Array[BrainCell],
	hidden_stat_type : String
) :
	
	# create object which hold the cell and quantity of total_hidden_stats
	var hidden_cell_objects = []
	
	for cell : BrainCell in new_prisoners :
		
		var total_hidden_stats_on_cell = 0
		
		if cell.strength_hidden :
			total_hidden_stats_on_cell += 1
		
		if cell.intelligence_hidden :
			total_hidden_stats_on_cell += 1
		
		if cell.community_hidden :
			total_hidden_stats_on_cell += 1
		
		# verify the cell has hidden on the correct stat		
		var cell_has_valid_hidden_stat : bool = false
		
		match hidden_stat_type :
			
			'strength' :
				if cell.strength_hidden :
					cell_has_valid_hidden_stat = true
			
			'intelligence' :
				if cell.intelligence_hidden :
					cell_has_valid_hidden_stat = true
			
			'community' :
				if cell.community_hidden :
					cell_has_valid_hidden_stat = true
		
		# skip invalid cells
		if not cell_has_valid_hidden_stat :
			continue
		
		# add valid object
		hidden_cell_objects.append({
			'cell' : cell,
			'total_hidden_stats' : total_hidden_stats_on_cell
		})
	
	# need atleast 2 matching hidden cells
	if len(hidden_cell_objects) < 2 :
		return null
	
	var selected_hidden_cell_obj = null
	
	for hidden_cell_obj in hidden_cell_objects :
		
		# if not one yet just set the var
		if not selected_hidden_cell_obj :
			selected_hidden_cell_obj = hidden_cell_obj
			continue
		
		var curr_total_hidden_stats = hidden_cell_obj['total_hidden_stats']
		var selected_total_hidden_stats = selected_hidden_cell_obj['total_hidden_stats']
		
		# if more hidden stats. thats the new selected cell
		if curr_total_hidden_stats > selected_total_hidden_stats :
			selected_hidden_cell_obj = hidden_cell_obj
		
		# if equal hidden stats, choose lower defect
		elif curr_total_hidden_stats == selected_total_hidden_stats :
			
			var curr_cell : BrainCell = hidden_cell_obj['cell']
			var selected_cell : BrainCell = selected_hidden_cell_obj['cell']
			
			var curr_defect : float
			var selected_defect : float
			
			match hidden_stat_type :
				
				'strength' :
					curr_defect = curr_cell.strength_defect
					selected_defect = selected_cell.strength_defect
				
				'intelligence' :
					curr_defect = curr_cell.intelligence_defect
					selected_defect = selected_cell.intelligence_defect
				
				'community' :
					curr_defect = curr_cell.community_defect
					selected_defect = selected_cell.community_defect
			
			# lower defect becomes selected
			if curr_defect < selected_defect :
				selected_hidden_cell_obj = hidden_cell_obj
			
			# tie breaker random
			elif curr_defect == selected_defect :
				
				var ran_num = randi_range(0, 100)
				
				if ran_num >= 50 :
					selected_hidden_cell_obj = hidden_cell_obj
	
	if selected_hidden_cell_obj == null :
		return null
	
	return selected_hidden_cell_obj['cell']
