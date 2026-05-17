extends Node

var current_collected_cell : BrainCell
var current_active_stat_indicator_index : int = 0

# componnets
@onready var screen_collected_cell_creator : Node2D = $CollectedCellTV/TvFrontPannel/SubViewport/CustomCollectedCellCreator
@export var name_manager : Node 



func _ready() -> void:
	
	
	current_collected_cell = BrainCell.new(
		'sample_name',
		0,
		0,
		0,
		3,
		0,
		0,
		0,
	)
	
	screen_collected_cell_creator._update_custom_cell_screen(current_collected_cell)

############## ACTIVE STAT INDICATOR ################
func _handle_change_active_stat_indicator_direction_btn(direction : String) -> void:
	
	# refers to [str, int, com] 
	var max_index : int = 5
	var min_index : int = 0

	match direction:
		
		'up':
			if current_active_stat_indicator_index < max_index:
				current_active_stat_indicator_index += 1
				screen_collected_cell_creator._update_active_stat_indicator(current_active_stat_indicator_index)
				
				

		'down':
			if current_active_stat_indicator_index > min_index:
				current_active_stat_indicator_index -= 1
				screen_collected_cell_creator._update_active_stat_indicator(current_active_stat_indicator_index)

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
			current_collected_cell.strength += increment_value
		1 : 
			current_collected_cell.strength_defect += increment_value 
		2 : 
			current_collected_cell.intelligence+= increment_value
		3 : 
			current_collected_cell.intelligence_defect += increment_value 
		4 : 
			current_collected_cell.community += increment_value
		5 : 
			current_collected_cell.community_defect += increment_value
			
	
	# finally update screen
	screen_collected_cell_creator._update_custom_cell_screen(current_collected_cell)
############################################

############## RESET ################
func _handle_reset_btn() -> void : 
	current_collected_cell = BrainCell.new(
		'head',
		0,
		0,
		0,
		3,
		0,
		0,
		0,
	)
	
	screen_collected_cell_creator._update_custom_cell_screen(current_collected_cell)
#####################################

############### CREATE #################
func _handle_create_btn() -> void:

	var new_name : String = name_manager.pick_prisoner_names()

	# create independent copy
	var created_cell = BrainCell.new(
		new_name,
		current_collected_cell.strength,
		current_collected_cell.intelligence,
		current_collected_cell.community,
		current_collected_cell.life_span,
		current_collected_cell.strength_defect,
		current_collected_cell.intelligence_defect,
		current_collected_cell.community_defect,
	)

	GLCreationZooBus.emit_signal(
		'admin_create_collected_cell',
		created_cell
	)
##########################################
