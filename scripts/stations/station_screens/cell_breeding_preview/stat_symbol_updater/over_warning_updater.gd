extends Node

# componnet over sprites
@onready var strenght_o_w : Sprite2D = $"../../Symbols/OverWarning/StrengthOverWarning"
@onready var intelligence_o_w : Sprite2D = $"../../Symbols/OverWarning/IntelligenceOverWarning"
@onready var community_o_w : Sprite2D = $"../../Symbols/OverWarning/CommunityOverWarning"


func _handle_detect_over_warning(key : String, cell_left : BrainCell, cell_right : BrainCell) :
	
	# [0] = high
	var high_low_stat : Array
	
	# get highest lowest stat
	match key :
		'str'  :
			high_low_stat = get_highest_lowest_stat(
				cell_left.strength.value,
				cell_right.strength.value
			)
			
		'int' :
			high_low_stat = get_highest_lowest_stat(
				cell_left.intelligence.value,
				cell_right.intelligence.value
			)
			
		'com' :
			high_low_stat = get_highest_lowest_stat(
				cell_left.community.value,
				cell_right.community.value
			)
			
		_:
			push_error('no key value found for _handle_detect_over_warning')
			return false
	
	
	# [0] = high stat
	var stat_value = high_low_stat[0]
	
	
	## CHECK IF INCREASING BEFORE CHECKING OVER
	var confirm_increase_event : bool = detect_increasing_event(
		high_low_stat
	)
	
	if not confirm_increase_event :
		return false
	
	
	# get correct target stat
	var target_cell = GLCellManagerBus.target_cell_refrence
	
	var target_stat : float
	
	match key :
		'str'  :
			target_stat = target_cell.strength.value
			
		'int' :
			target_stat = target_cell.intelligence.value
			
		'com' :
			target_stat = target_cell.community.value
			
		_:
			push_error('no key value found for _handle_detect_over_warning')
			return false
		
	
	## evalute how far from the MAX LIMIT the target stat is		if over_warning_active :

	var target_to_max_distance = (
		IVCellCreator.max_stat_value - target_stat
	)
	
	## depending on that distance find threshold
	var target_to_max_distance_scaled = (
		target_to_max_distance * IVCellBreeding.over_stat_extreme_scale
	)
	
	var min_to_activate_random_change_mode = target_stat + target_to_max_distance_scaled
	
	# min to activate random change mode
	if stat_value >= min_to_activate_random_change_mode :
		return true
	else :
		return false
	
		
		
func detect_increasing_event(high_low_stat : Array) -> bool :
	
	# see if it reaches minimum passing increase score
	var increase_case_min = (
		high_low_stat[0]
		* IVCellBreeding.clean_stat_increase_case_min
	)

	if high_low_stat[1] >= increase_case_min :
		return true
	else :
		return false
		
		
func get_highest_lowest_stat(stat_1, stat_2) :
	var high_stat : float
	var low_stat : float
	
	if stat_1 >= stat_2 :
		high_stat = stat_1
		low_stat = stat_2
	else :
		high_stat = stat_2
		low_stat = stat_1
	
	return [high_stat, low_stat]
	
	
#####################
	
func _display_over_warning(stat_type : String) :
	match stat_type :
		'strength' :
			strenght_o_w.visible = true
			
		'intelligence' :
			intelligence_o_w.visible = true
			
		'community' :
			community_o_w.visible = true

###################

func _reset_symbols() : 
	strenght_o_w.visible = false
	intelligence_o_w.visible = false
	community_o_w.visible = false
	
