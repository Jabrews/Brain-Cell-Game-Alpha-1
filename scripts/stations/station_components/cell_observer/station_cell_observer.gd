extends Node

# componets
@onready var screen_cell_observer : Node2D = $ObserverTV/TvFrontPannel/SubViewport/ScreenCellObserver
@onready var screen_observer_list_index  :Node2D = $ListIndexTV/TvFrontPannel/SubViewport/ScreenObserverListIndex


@onready var stat_display : Control = $ObserverTV/TvFrontPannel/SubViewport/ScreenCellObserver/StatDisplay
@onready var no_cell_stat_display : Control = $ObserverTV/TvFrontPannel/SubViewport/ScreenCellObserver/NoCellDisplay

var observed_index : int = 0
var observed_list : Array[BrainCell]


func _ready() -> void:
	GLCellManagerBus.connect('cells_updated', update_observed_list)
	
	# startup update
	update_observed_list()
	screen_observer_list_index.update_list_curr(observed_index)
	screen_observer_list_index.update_list_max(observed_list)


func _move_button_pressed(button_side : String) :
		
	# update list
	update_observed_list()
	
	var potential_index = observed_index
	
	# increment potential index
	if button_side == 'left' : 		
		potential_index -= 1
		
	elif button_side == 'right' :
		potential_index += 1
		
	else :
		push_error('observer non valid button side found')
		return
	
	
	var button_increment_valid : bool = verify_observed_index_exist(potential_index)
	
	if button_increment_valid :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
		observed_index = potential_index
		screen_observer_list_index.update_list_curr(observed_index)
		update_screen()
	else :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return


func update_display() :
	
	if len(observed_list) == 0 :
		stat_display.visible = false
		no_cell_stat_display.visible = true
		
	else :
		stat_display.visible = true 
		no_cell_stat_display.visible = false 


func update_observed_list() :
	
	# get collected cells
	var new_observed_list : Array[BrainCell] = GLCellManagerBus.collected_cells_refrence.duplicate()
	
	# get target cell
	var target_cell : BrainCell = GLCellManagerBus.target_cell_refrence
	
	# add target cell if valid
	if target_cell :
		new_observed_list.append(target_cell)
	
	# update observed list
	observed_list = new_observed_list
	
	# update display
	update_display()
	screen_observer_list_index.update_list_max(observed_list)

	
	
	# if no cells reset index and stop
	if len(observed_list) == 0 :
		observed_index = 0
		return
	
	
	# clamp index to valid range
	observed_index = clamp(observed_index, 0, len(observed_list) - 1)
	
	
	# update observer screen
	update_screen()


func verify_observed_index_exist(potential_index : int) :
	
	# if going pass list max
	if potential_index > len(observed_list) - 1 :
		return false
		
	elif potential_index < 0 :
		return false
		
	else :
		return true


func update_screen() : 	
	
	# safety check
	if len(observed_list) == 0 :
		return
	
	# get active cell
	var active_cell : BrainCell = observed_list[observed_index]
	
	# update observer
	screen_cell_observer._handle_observer_cell_recieved(active_cell)
