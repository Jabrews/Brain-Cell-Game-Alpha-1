extends Node

## POSSIBLE TODO : 
# very large file. possibly spread apart like cleanstat_helper


func generate_defect_stats(cell_1 : BrainCell, cell_2 : BrainCell) -> Array[int] :

	# find highest vs lowest stat
	var str_stat_array : Array= get_highest_lowest_stat(cell_1.strength.defect, cell_2.strength.defect)
	var int_stat_array : Array= get_highest_lowest_stat(cell_1.intelligence.defect, cell_2.intelligence.defect)
	var com_stat_array : Array= get_highest_lowest_stat(cell_1.community.defect, cell_2.community.defect)
	
	# evaluate what % of highstat low stat should exist up to 
	var str_increase_case_min = str_stat_array[0] * IVCellBreeding.defect_stat_increase_case_min
	var int_increase_case_min = int_stat_array[0] * IVCellBreeding.defect_stat_increase_case_min
	var com_increase_case_min = com_stat_array[0] * IVCellBreeding.defect_stat_increase_case_min
	
	# new clean stats
	var strength_defect : float
	var intelligence_defect : float
	var community_defect : float
	
	strength_defect = ressolve_defect_stat(str_stat_array[0], str_stat_array[1], str_increase_case_min)
	intelligence_defect = ressolve_defect_stat(int_stat_array[0], int_stat_array[1], int_increase_case_min)	
	community_defect = ressolve_defect_stat(com_stat_array[0], com_stat_array[1], com_increase_case_min)
	
	return [strength_defect, intelligence_defect, community_defect]
	
	
func ressolve_defect_stat(high_stat: float, low_stat: float, increase_case_min : float) :
	
	var new_defect_value : float
	
	# defect increase mode	
	if increase_case_min <= low_stat:
		new_defect_value = increase_defect_stat_case(high_stat, low_stat)
	# defect decrease mode
	else :
		new_defect_value = decrease_defect_stat_case(high_stat, low_stat)
	
	
	# prevent from going below 0	
	if new_defect_value < 0 :
		new_defect_value = 0
	
	return new_defect_value

func increase_defect_stat_case(high_stat : float, low_stat : float) :
	
	# find high_stat distance to max value
	var high_percent_of_max = high_stat + low_stat / IVCellCreator.max_stat_value
	
	var new_defect_value : float
	
	
	# depending on value increase the defect stat 
	# 0.1 10% of max | 1.0 100% of max

	# add even past the two stats combined
	#ONE
	if high_percent_of_max <= 0.20 : 
		new_defect_value = high_stat + low_stat + (low_stat * IVCellBreeding.defect_stat_increase_one_scale)

	# just plainly add two stats
	#TWO
	elif high_percent_of_max > 0.30 and high_percent_of_max <= 0.60 :
		new_defect_value = high_stat + low_stat 

	# add two stats at slight reduction
	#THREE
	elif high_percent_of_max > 0.60 and high_percent_of_max <= 0.80 :
		new_defect_value = high_stat + (low_stat * IVCellBreeding.defeect_stat_increase_three_scale)

	# add two stat at greater reduction
	# between 80 and 90
	#FOUR
	elif high_percent_of_max > 0.80 and high_percent_of_max <= 0.90 :
		new_defect_value = high_stat + (low_stat * IVCellBreeding.defect_stat_increase_four_scale)

	# after this just mostly use default (players prolly fucked)
	else :
	#FIVE
		new_defect_value = high_stat + low_stat
		
	return new_defect_value
	

func decrease_defect_stat_case(high_stat : float, low_stat : float ) :
	
	var new_defect_value : float	
	
	# evaluate what % of max value high_stat occupies
	var high_percent_of_max = high_stat / IVCellCreator.max_stat_value
	
	# if under max stat value. decrease normally
	if high_percent_of_max < 0.50 : 
		new_defect_value = high_stat - low_stat * IVCellBreeding.defect_stat_decrease_one_scale # 1.0 by default
	
	# heavily decrease defect at high corruption
	else :
		new_defect_value = high_stat - (
			low_stat + (
				low_stat * IVCellBreeding.defect_stat_decrease_two_scale
			)
		)
	
	return new_defect_value


	
		

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
