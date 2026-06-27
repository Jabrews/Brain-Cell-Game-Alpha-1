extends Node

func _create(stat_constructor : StatConstructor) -> BrainCellStat :
	
	# if stat is disabled return null	
	if stat_constructor.stat_enabled == false:
		return BrainCellStat.new(
			stat_constructor.stat_type,
			false,
			0.0,
			0.0,
			false,
		)
	
	var stat_value = generate_random_stat_value(stat_constructor.stat_base_clean_value)
	
	stat_value = apply_spare_symbol(stat_value, stat_constructor.spare_symbol)
	
	stat_value = clamp(stat_value, 1, IVCellCreator.max_stat_value) 
	stat_value = round(stat_value* 10.0) / 10.0
	
	return BrainCellStat.new(
		stat_constructor.stat_type,
		true,
		stat_value,
		0.0,
		false,
	)
	

func generate_random_stat_value(stat_base : float) :
	
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

func apply_spare_symbol(stat_value : float, spare_symbol : StatSpareSymbol ) -> float:

	if spare_symbol.type == "none":
		return stat_value

	else:
		return stat_value
