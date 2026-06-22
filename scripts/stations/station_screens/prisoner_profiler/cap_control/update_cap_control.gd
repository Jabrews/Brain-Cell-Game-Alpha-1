extends Node

@onready var parent_stat_control_panel : Node3D = $"../../../../.."
@onready var helper_gets_stats_clean_range : Node = $HelperGetStatsCleanRange
@onready var symbol_range_manager : Node = $"../SymbolRangeManager"

var parent_stat_type : String

# NOTICE 
# caution range will only include range of 2. ex. : low -> low-mid 
# warning range can include more. ex. : low -> mid (low-mid in bewteen)

func _ready() -> void:
	parent_stat_type = parent_stat_control_panel.stat_type
	
	_handle_proceed_next_round()
	
	GLCellManagerBus.connect('cell_added_to_collection', _handle_cell_added_to_collection)
	GLCellManagerBus.connect('cell_breeded', _handle_cell_breeded)
	GLGameManagerBus.connect('proceed_next_round', _handle_proceed_next_round)

func _handle_cell_breeded(_old_cell_1, _old_cell_2, new_cell : BrainCell) :
	_handle_cell_added_to_collection(new_cell)

func _handle_cell_added_to_collection(new_collected_cell : BrainCell):
	
	var new_stat : float
	
	match parent_stat_type:
		'strength':
			new_stat = new_collected_cell.strength.value
		'intelligence':
			new_stat = new_collected_cell.intelligence.value
		'community':
			new_stat = new_collected_cell.community.value
	
	var stats_respected_clean_range : String = helper_gets_stats_clean_range._get_clean_range(new_stat)
	
	var caution_ranges : Array[String] = symbol_range_manager.get_caution_ranges()
	
	if caution_ranges.has(stats_respected_clean_range):
		var push_back_valid : bool = caution_push_back_stat_cap(
			stats_respected_clean_range,
			caution_ranges
		)
		
		if push_back_valid:
			return
	
	var warning_ranges : Array[String] = symbol_range_manager.get_warning_ranges()
	
	if warning_ranges.has(stats_respected_clean_range):
		var warning_push_back_valid : bool = warning_push_back_stat_cap(
			stats_respected_clean_range,
			warning_ranges
		)
		
		if warning_push_back_valid:
			return


func caution_push_back_stat_cap(new_clean_range_min : String, caution_ranges : Array[String]) -> bool:
	
	var index_inside_of_caution_ranges = caution_ranges.find(new_clean_range_min)
	
	if index_inside_of_caution_ranges == 0:
		
		symbol_range_manager.caution_left_point_index += 1
		symbol_range_manager.caution_right_point_index += 1
		
		push_warning_forward()
		
		var max_index = 4
		
		if symbol_range_manager.caution_left_point_index >= max_index:
			disable_stat_cap('caution')
			disable_stat_cap('warning')
			return true
		
		symbol_range_manager.set_symbol('caution')
		return true
	
	return false


func warning_push_back_stat_cap(new_clean_range_min : String, warning_ranges : Array[String]) -> bool:
	
	var index_inside_of_warning_ranges = warning_ranges.find(new_clean_range_min)
	
	if index_inside_of_warning_ranges == 0:
		
		symbol_range_manager.warning_left_point_index += 1
		
		var max_index = 4
		
		if symbol_range_manager.warning_left_point_index >= max_index:
			disable_stat_cap('warning')
			return true
		
		symbol_range_manager.set_symbol('warning')
		return true
	
	return false


func push_warning_forward() -> void:
	
	symbol_range_manager.warning_left_point_index += 1
	
	var max_index = 4
	
	if symbol_range_manager.warning_left_point_index >= max_index:
		disable_stat_cap('warning')
		return
	
	symbol_range_manager.set_symbol('warning')


func disable_stat_cap(symbol_type : String) -> void:
	
	match symbol_type:
		
		'caution':
			symbol_range_manager.toggle_hide_symbol('caution', false)
		
		'warning':
			symbol_range_manager.toggle_hide_symbol('warning', false)


func _handle_proceed_next_round() -> void:
	
	symbol_range_manager.toggle_hide_symbol('caution', true)
	symbol_range_manager.toggle_hide_symbol('warning', true)
	
	
	symbol_range_manager.caution_left_point_index = 1
	symbol_range_manager.caution_right_point_index = 2
	symbol_range_manager.set_symbol('caution')
	
	symbol_range_manager.warning_left_point_index = 2
	symbol_range_manager.warning_right_point_index = 4
	symbol_range_manager.set_symbol('warning')
