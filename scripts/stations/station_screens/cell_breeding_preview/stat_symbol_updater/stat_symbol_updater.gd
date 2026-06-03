extends Node

# logic components
@onready var arrow_updater : Node = $ArrowUpdater
@onready var checkmark_updater : Node = $CheckmarkUpdater
@onready var question_mark_updater : Node = $QuestionMarkUpdater
@onready var over_warning_updater : Node = $OverWarningUpdater
@onready var disabled_stat_updater : Node = $DisabledStatUpdater

# display components 
@onready var arrow_labels_parent : Control = $"../Symbols/Arrows"
@onready var checkmark_parent : Control = $"../Symbols/CheckMarks"
@onready var question_mark_parent : Control = $"../Symbols/QuestionMarks"
@onready var over_warning_parent : Control = $"../Symbols/OverWarning"

var left_cell : BrainCell
var right_cell : BrainCell


func _load_breeding_panel_cell(panel_side : String, cell : BrainCell) :
	
	if panel_side == 'left' : 	
		left_cell = cell 
	
	if panel_side == 'right' :
		right_cell = cell
	
	handle_display_symbols(panel_side, cell)
	

func handle_display_symbols(panel_side : String, cell : BrainCell) :
	
	# hide or unhide symbols
	handle_display_hidden()
	
	# update checkmarks
	checkmark_updater._handle_checkmarks(panel_side, cell)
	
	# only continue if both cells exist
	if not left_cell or not right_cell :
		reset_all_symbols()
		return
	
	elif left_cell and right_cell :
		reset_all_symbols()
		process_cell_symbols()
	
func process_cell_symbols() :
	
	var stat_dict = ['str', 'int', 'com']
		
	for key in stat_dict :
		
		
		# 0. check disabled
		var disabled_stat_active = disabled_stat_updater._handle_check_disabled(
			key,
			left_cell,
			right_cell
		)
		
		# dont continue if this is the case
		if disabled_stat_active :
			handle_display_icon(key, 'disabled')
			continue
		
		# 1. hidden stat
		var question_mark_active = question_mark_updater._handle_detect_question_mark(
			key,
			left_cell,
			right_cell,
		)
		
		if question_mark_active :
			handle_display_icon(key, 'question')
			continue
		
		# 2. over warning
		var over_warning_active = over_warning_updater._handle_detect_over_warning(
			key,
			left_cell,
			right_cell,
		)
		
		if over_warning_active :
			handle_display_icon(key, 'over')
			continue
		
		## AT THIS POINT IT HAS TO BE ARROW SO NOW WE FIND TYPE AND PROPERTIES
		
		# 3. arrow
		# see what arrow type (up or down) (inc or dec)
		var arrow_type_active = arrow_updater._handle_arrow_type(
			key,
			left_cell,
			right_cell,
		)
		
		# get arrow phase (1-3)
		# 1 - not moving 
		# 2 - slightly scale and scale
		# 3 - heavily scale and rotate AND moves
		var arrow_phase : int = arrow_updater._handle_arrow_phase(
			arrow_type_active,
			key,
			left_cell,
			right_cell,
		)
		
		handle_display_icon(key, arrow_type_active, arrow_phase)
		# 
		
		
				
func handle_display_icon(key : String, icon_type : String, arrow_phase = 0):
	
	if icon_type == 'disabled' :	
		# if disabled we get no icons
		return
	
	elif icon_type == 'question' :
		match key :
			'str' :
				question_mark_updater._display_question_mark('strength')
			'int' :
				question_mark_updater._display_question_mark('intelligence')
			'com' :			
				question_mark_updater._display_question_mark('community')
	
	elif icon_type == 'over' :
		match key :
			'str' :
				over_warning_updater._display_over_warning('strength')
			'int' :
				over_warning_updater._display_over_warning('intelligence')
			'com' :			
				over_warning_updater._display_over_warning('community')
	
	elif icon_type == 'down' or icon_type == 'up' :
		match key :
			'str' :
				arrow_updater._display_arrow('strength', icon_type, arrow_phase)

			'int' :
				arrow_updater._display_arrow('intelligence', icon_type, arrow_phase)

			'com' :			
				arrow_updater._display_arrow('community', icon_type, arrow_phase)
		
	
func handle_display_hidden(): 
	
	if not left_cell or not right_cell :
		arrow_labels_parent.visible = false			
		question_mark_parent.visible = false
		over_warning_parent.visible = false
		
		
	
	elif left_cell and right_cell :
		arrow_labels_parent.visible = true
		question_mark_parent.visible = true 
		over_warning_parent.visible = true 
		
		
func reset_all_symbols() :
	arrow_updater._reset_symbols()
	question_mark_updater._reset_symbols()
	over_warning_updater._reset_symbols()



	
	
