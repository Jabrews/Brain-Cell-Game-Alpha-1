extends Node

class_name IncreaseCleanStatCase


func increase_clean_stat_case(stat_high : float, stat_low : float, target_stat : float) : 
	
	## find diff. of high & low	
	var diff_value = stat_high - stat_low
	
	## find possible finale value after increase
	var possible_add_value = stat_high + diff_value
	
	## evaluate what % of add_value sits inside of target
	# 0.0 add value is 0 (bad)
	# 1.0 add value is equal to target 
	# 0.5 add value is halfway to target
	var add_percant = possible_add_value / target_stat
	
	
	## create finale value	
	# low (under 0.5)
	if add_percant <= 0.5:
		
		# DEBUG 
		#print('under half of target  :', stat_high, ' ', stat_low)
		#stat_high += stat_low 
		
		var curr_energy = GLGameManagerBus.curr_energy
		var max_energy = GLGameManagerBus.max_energy
		
		var half_energy = max_energy * 0.5
		
		# late game: scale increase
		if curr_energy >= half_energy :
			stat_high += (stat_low * IVCellBreeding.low_add_percant_scale)
		else:
			# early game: apply full increase
			stat_high += stat_low 
	
	# high (over 0.5) but not over target (under 1.0)
	elif add_percant > 0.5 and add_percant < 1.0:
		
		# DEBUG
		#print('over half of target  :', stat_high, ' ', stat_low)
		#stat_high += stat_low
		
		var curr_energy = GLGameManagerBus.curr_energy
		var max_energy = GLGameManagerBus.max_energy
		
		var half_energy = max_energy * 0.5
		
		# late game scale increase
		if curr_energy  >= half_energy:
			var predicted = stat_high + (stat_low * IVCellBreeding.high_add_percant_scale)
			
			# if within 20 point range. auto set to target value		
			if abs(predicted - target_stat) <= 20:
					stat_high = target_stat
			else:
				stat_high = predicted
				
		# early game " apply full increase
		else:
			stat_high += stat_low 
	#
	## round 1 decimal point
	stat_high = round(stat_high * 10.0) / 10.0
	
	# if finle new stat is over the max stat value. clamp to max value
	if stat_high > IVCellCreator.max_stat_value :
		stat_high = IVCellCreator.max_stat_value
	
	return stat_high


func debug_get_stat_high() :
	pass
