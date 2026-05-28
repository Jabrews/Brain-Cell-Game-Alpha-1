extends Node

var increase_clean_stat_case : IncreaseCleanStatCase
var decrease_clean_stat_case : DecreaseCleanStatCase
var over_clean_stat_case : OverCleanStatCase

func _ready() -> void:
	# init case classes
	increase_clean_stat_case = IncreaseCleanStatCase.new()
	decrease_clean_stat_case = DecreaseCleanStatCase.new()
	over_clean_stat_case = OverCleanStatCase.new()


func generate_clean_stats(cell_1 : BrainCell, cell_2 : BrainCell) -> Array[int] :

	# find highest vs lowest stat
	var str_stat_array : Array= get_highest_lowest_stat(cell_1.strength, cell_2.strength)
	var int_stat_array : Array= get_highest_lowest_stat(cell_1.intelligence, cell_2.intelligence)
	var com_stat_array : Array= get_highest_lowest_stat(cell_1.community, cell_2.community)
	
	# evaluate what % of highstat low stat should exist up to 
	var str_increase_case_min = str_stat_array[0] * IVCellBreeding.clean_stat_increase_case_min
	var int_increase_case_min = int_stat_array[0] * IVCellBreeding.clean_stat_increase_case_min
	var com_increase_case_min = com_stat_array[0] * IVCellBreeding.clean_stat_increase_case_min
	
	# target refrence
	var target_cell = GLCellManagerBus.target_cell_refrence
	
	# new clean stats
	var strength : float
	var intelligence : float
	var community : float
	
	strength = resolve_clean_stat(str_stat_array, target_cell.strength, str_increase_case_min)
	intelligence = resolve_clean_stat(int_stat_array, target_cell.intelligence, int_increase_case_min)
	community = resolve_clean_stat(com_stat_array, target_cell.community, com_increase_case_min)
	
	return [strength, intelligence, community]
	
func resolve_clean_stat(stat_array : Array, target_value : float, increase_case_min : float) -> float:
	var stat_high = stat_array[0]
	var stat_low = stat_array[1]
	
	

	# increase case
	if increase_case_min <= stat_low:
		var result = increase_clean_stat_case.increase_clean_stat_case(stat_high, stat_low, target_value)
		
		# over case
		if stat_high >= target_value:
			result = over_clean_stat_case.over_clean_stat_case(stat_high, stat_low, target_value)
		
		return result
	
	else : 
	
		# dont do decrease case if both are values
		var early_game_small_stats = handle_detect_early_stats(stat_high, stat_low, target_value)
		if early_game_small_stats :
			var result = increase_clean_stat_case.increase_clean_stat_case(stat_high, stat_low, target_value)
			return result
		
		
		
		# decrease case
		return decrease_clean_stat_case.decrease_clean_stat_case(stat_high, stat_low, target_value)

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

func handle_detect_early_stats(stat_high : float, stat_low : float, target_value : float)  -> bool :
	
	var small_stat_range_max = target_value * 0.2
		
	# both stats are below 20% of target
	if stat_high < small_stat_range_max and stat_low < small_stat_range_max :
		return true
	else : 
		return false
		
		
	



	
