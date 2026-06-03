extends Node

class_name DecreaseCleanStatCase


func decrease_clean_stat_case(stat_high : float, stat_low : float, target_stat : float) : 
	
	## find diff. of high & low	
	var diff_value = stat_high - stat_low
	
	## find possible finale value after decrease
	var possible_decrease_value = stat_high - diff_value
	
	## evaluate what % of decrease_value sits inside of target
	# 0.0 decrease value is 0 (bad)
	# 1.0 decrease value is equal to target 
	# 0.5 decrease value is halfway to target
	var decrease_percant = possible_decrease_value / target_stat
	
	
	## create finale value	
	# low (under 0.5)
	if decrease_percant <= 0.5:
		
		# DEBUG 
		#print('under half of target  :', stat_high, ' ', stat_low)
		#stat_high -= stat_low 
		
		var curr_round = GLGameManagerBus.current_round
		var max_round = GLGameManagerBus.max_rounds
		
		var half_round = max_round * 0.5
		
		# late game: scale decrease
		if curr_round >= half_round:
			stat_high -= (stat_low * IVCellBreeding.low_subtract_percant_scale)
			
		# early game: apply full decrease
		else:
			stat_high -= stat_low 
	
	
	# high (over 0.5) but not over target (under 1.0)
	elif decrease_percant > 0.5 and decrease_percant < 1.0:
		
		# DEBUG
		#print('over half of target  :', stat_high, ' ', stat_low)
		#stat_high -= stat_low
		
		var curr_round = GLGameManagerBus.current_round
		var max_round = GLGameManagerBus.max_rounds
		
		var half_round = max_round * 0.5
		
		# late game scale decrease
		if curr_round >= half_round:
			var predicted = stat_high - (stat_low * IVCellBreeding.high_subtract_percant_scale)
			
			# if within 20 point range. auto set to target value		
			if abs(predicted - target_stat) <= 20:
				stat_high = target_stat
			else:
				stat_high = predicted
		
		# early game: apply full decrease
		else:
			stat_high -= stat_low 
	
	
	# invalid range
	elif decrease_percant > 1.0:
		push_error('high_stat decrease pushes past expected range')
	
	
	## round 1 decimal point
	stat_high = round(stat_high * 10.0) / 10.0
	
	
	# if finale new stat is over the max stat value. clamp to max value
	if stat_high > IVCellCreator.max_stat_value :
		stat_high = IVCellCreator.max_stat_value
	
	
	return stat_high


func debug_get_stat_high() :
	pass
