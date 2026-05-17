extends Node

var current_target_cell : BrainCell
var current_active_stat_indicator_index : int = 0

# componnets
@onready var screen_target_cell_creator : Node2D = $TargetTV/TvFrontPannel/SubViewport/ScreenCustomTargetCellCreator


func _ready() -> void:
	current_target_cell = BrainCell.new(
		'head',
		0,
		0,
		0,
		3,
		0,
		0,
		0,
	)
	
	screen_target_cell_creator._update_custom_cell_screen(current_target_cell)

############## ACTIVE STAT INDICATOR ################
func _handle_change_active_stat_indicator_direction_btn(direction : String) -> void:
	
	# refers to [str, int, com] 
	var max_index : int = 2
	var min_index : int = 0

	match direction:
		
		'up':
			if current_active_stat_indicator_index < max_index:
				current_active_stat_indicator_index += 1
				screen_target_cell_creator._update_active_stat_indicator(current_active_stat_indicator_index)
				
				

		'down':
			if current_active_stat_indicator_index > min_index:
				current_active_stat_indicator_index -= 1
				screen_target_cell_creator._update_active_stat_indicator(current_active_stat_indicator_index)

		_:
			push_error('change active stat indicator btn: invalid direction')
##############################################

############## CHANGE VALUE ################
func _handle_increment_target_stat_btn(increment_type : String) -> void :
	
	var increment_value : int = 0
	
	# set increment_value 
	match increment_type :	
		'increase' : 		
			increment_value = 20
		'decrease' :
			increment_value = -20
		_ :
			push_error('invalid increment target stat btn increment_type')
	
	# update respected stat
	match current_active_stat_indicator_index : 
		0 : 
			current_target_cell.strength += increment_value
		1 : 
			current_target_cell.intelligence += increment_value
		2 : 
			current_target_cell.community += increment_value
	
	# finally update screen
	screen_target_cell_creator._update_custom_cell_screen(current_target_cell)
############################################

############## RESET ################
func _handle_reset_btn() -> void : 
	current_target_cell = BrainCell.new(
		'head',
		0,
		0,
		0,
		3,
		0,
		0,
		0,
	)
	
	screen_target_cell_creator._update_custom_cell_screen(current_target_cell)
######################################

############### LOCK IN #################
func _handle_lock_in_target_cell() :
	GLCreationZooBus.emit_signal('admin_create_target_cell', current_target_cell)

#########################################
