extends Node

func _create(stat: BrainCellStat, stat_cap_status : String) -> float:
	
	# if disabled no defect value	
	if stat.enabled == false :
		return 0.0
		
	var stat_value = generate_random_stat_value(stat.value)
	
	stat_value = detect_and_apply_stap_cap(stat_value, stat_cap_status)
	
	return stat_value

func generate_random_stat_value(stat_value : float) :
	
	var random_change = randi_range(-40, 30)
		
	stat_value += random_change
	
	return stat_value 

func detect_and_apply_stap_cap(stat_value : float, stat_cap_status : String):
	
	if stat_cap_status == "none":
		return stat_value

	elif stat_cap_status == "caution":
		var random_change = randi_range(30, 50)
		stat_value += random_change

	elif stat_cap_status == "warning":
		var random_change = randi_range(50, 60)
		stat_value += random_change

	else:
		push_error("invalid stat cap: %s" % stat_cap_status)
		return stat_value

	return stat_value

	
