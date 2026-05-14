extends Node

# station owner
var station_refrence : Node # is set on ready
# interpreter type
var interpreter_type : String # is set on ready
# current active panel cell
var panel_cell : BrainCell


# componnets
@onready var screen_swap_handler : Node = $ScreenSwapHandler
@onready var interpreter_screen : Control = $InterpreterScreen
@onready var stat_name_label_1 : Label = $NoCellDetected/StatName
@onready var stat_name_label_2 : Label = $InterpreterScreen/StatName
@onready var interpreter_invalid_stat_sound : AudioStreamPlayer3D = $InterpreterInvalidStatSound


func _ready() -> void:
	
	await get_tree().process_frame
	
	# spread interpreter type to labels
	stat_name_label_1.text = interpreter_type
	stat_name_label_2.text = interpreter_type


################ PANEL CELL LOGIC ################
func _handle_panel_body_recieved(
	container_body : CharacterBody3D
) -> void:
	
	# update active station container
	if container_body :
		station_refrence.set_active_container(container_body)
		
		# update active cell
		panel_cell = container_body.designated_brain_cell
	
	# if body removed
	else :
		panel_cell = null
		handle_panel_cell_removed()
		return
	
	# prevent interpreter reruns during jolt
	if station_refrence.jolt_active :
		return
	
	# continue normal logic
	handle_panel_cell_loaded()


func handle_panel_cell_removed() -> void:
	
	# clear interpreter progress
	interpreter_screen._load_panel_cell(null)
	
	# clear active station container
	station_refrence.clear_active_container()
	
	# if currently jolting, remain on jolt screen
	if station_refrence.jolt_active :
		return
	
	# otherwise return to no-cell screen
	screen_swap_handler.swap_screen('no_cell')


func handle_panel_cell_loaded() -> void:
	
	if not panel_cell :
		return
	
	# verify hidden stat exists
	var cell_has_hidden_stat : bool = check_cell_has_hidden_stat(panel_cell)
	
	# if invalid hidden stat
	if not cell_has_hidden_stat :
		screen_swap_handler.swap_screen('no_hidden')
		interpreter_invalid_stat_sound.play()
		interpreter_screen._load_panel_cell(null)
		return
	
	# start interpreter
	screen_swap_handler.swap_screen('interpreter')
	interpreter_screen._load_panel_cell(panel_cell)


func check_cell_has_hidden_stat(cell : BrainCell) -> bool:
	
	match interpreter_type :
		
		'strength' :
			return cell.strength_hidden
		
		'intelligence' :
			return cell.intelligence_hidden
		
		'community' :
			return cell.community_hidden
			
	
	return false
###############################################


#################### JOLT UI #####################
func enter_jolt_mode() -> void:
	
	# stop interpreter progress
	interpreter_screen._load_panel_cell(null)
	
	# show jolt screen
	screen_swap_handler.swap_screen('jolt_detected')


func exit_jolt_mode() -> void:
	
	# if cell still exists restart interpreter
	if panel_cell :
		handle_panel_cell_loaded()
	
	# otherwise return to no-cell screen
	else :
		screen_swap_handler.swap_screen('no_cell')
###################################################
