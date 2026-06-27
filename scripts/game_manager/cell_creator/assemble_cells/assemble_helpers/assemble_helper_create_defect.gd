extends Node

func _create(stat: BrainCellStat, spare_symbol : StatSpareSymbol) -> float:
	
	# if disabled no defect value	
	if stat.enabled == false :
		return 0.0
		
	var stat_value = generate_random_stat_value(stat.value)
	
	stat_value = apply_spare_symbol(stat_value, spare_symbol)
	
	return stat_value

func generate_random_stat_value(stat_base: float) :
	
	var random_1 = stat_base + 6
	var random_2 = stat_base - 6
	var random_3 = stat_base + 8
	var random_4 = stat_base - 8
	var random_5 = stat_base + 12
	var random_6 = stat_base - 12
	var random_7 = stat_base - 15
	var random_8 = stat_base - 20
	var random_9 = stat_base - 22
	
	var random_diffrence_array = [random_1, random_2, random_3, random_4, random_5, random_6, random_7, random_8, random_9]
	stat_base = random_diffrence_array.pick_random()
	
	return stat_base

func apply_spare_symbol(stat_value : float, spare_symbol : StatSpareSymbol):
	
	if spare_symbol.type == "none":
		return stat_value
	
	if spare_symbol.type == 'defect' :
		
		if spare_symbol.direction == 'up' :		
			stat_value += randi_range(30, 50)
		elif spare_symbol.direction == 'down' :
			stat_value -= randi_range(30, 50)
		else :
			push_error('direction not found for spare symbol : ', spare_symbol)
			
		return stat_value

	else:
		return stat_value

	
