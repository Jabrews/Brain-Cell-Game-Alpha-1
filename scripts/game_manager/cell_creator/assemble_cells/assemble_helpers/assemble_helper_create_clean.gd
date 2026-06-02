extends Node

func _create(stat_constructor : StatConstructor) :
	
	#var target_stat : float = get_corrispondin
	
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
	
	stat_value = detect_and_apply_stap_cap(stat_value, stat_constructor.stat_cap_status)
	
	stat_value = clamp(stat_value, 0, IVCellCreator.max_stat_value) 
	stat_value = round(stat_value* 10.0) / 10.0
	
	return BrainCellStat.new(
		stat_constructor.stat_type,
		true,
		stat_value,
		0.0,
		false,
	)
	
	
func get_corrisponding_target_stat(stat_type : String) -> float :
	
	var target_cell : BrainCell = GLCellManagerBus.target_cell_refrence
	
	match stat_type : 
		'strength' :
			return target_cell.strength.value
		'intelligence' :
			return target_cell.intelligence.value
		'community' :		
			return target_cell.community.value
		_ :
			push_error('invalid stat_type')
			return 0.0

func generate_random_stat_value(stat_base : float) :
	
	var random_change = randi_range(-50, 20)
	stat_base += random_change
	
	return stat_base

func detect_and_apply_stap_cap(stat_value : float, stat_cap_status : String ) -> float:

	if stat_cap_status == "none":
		return stat_value

	elif stat_cap_status == "caution":
		var random_change = randi_range(-30, -10)
		stat_value += random_change

	elif stat_cap_status == "warning":
		var random_change = randi_range(-40, -20)
		stat_value += random_change

	else:
		push_error("invalid stat cap: %s" % stat_cap_status)
		return stat_value

	return stat_value
