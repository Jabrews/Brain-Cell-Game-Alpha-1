extends Node

@export var interpreter_type: String

var interpreter_active: bool = false
var active_brain_cell_container: CharacterBody3D = null

var current_screen: String = "INFO_SCREEN"
var current_info_screen_type: String = "NO_CELL_DETECTED"

var player_sitting_in_chair : bool = false

var jolt_active : bool = false



# components helpers
@onready var timer_increment: Node = $TimerIncrement
@onready var screen_hidden_interpreter: Node2D = $InterpreterTV/TvFrontPannel/SubViewport/ScreenHiddenInterpreter
@onready var audio_manager : Node3D = $AudioManager

# jolt 
@onready var jolt_particles : GPUParticles3D = $JoltParticles
@onready var energy_decrease_spawner : Node3D = $EnergyDecreaseSpawner


## this is the game screen the hidden stat interpreter loads
@export var game_screen_scene : PackedScene 



func _ready() -> void:
	switch_screen("INFO_SCREEN", "NO_CELL_DETECTED")
	
	GLDefectEventMangerBus.connect('event_hidden_stat_interpreter_jolt', _handle_defect_event_jolt)	


#### STATE MACHINE ####
func switch_screen(type: String, info_screen_type: String = "") -> void:
	
	if jolt_active :	
		return
	
	if type != "INFO_SCREEN" and not active_brain_cell_container:
		type = "INFO_SCREEN"
		info_screen_type = "NO_CELL_DETECTED"
	
	current_screen = type

	if type == "INFO_SCREEN":
		current_info_screen_type = info_screen_type
		audio_manager.toggle_play_idle_drone(false)
		_handle_info_screen_type(info_screen_type)

	elif type == "IDLE_SCREEN":
		timer_increment._start_timer()

	elif type == "GAME_SCREEN":
		timer_increment._start_timer()

	screen_hidden_interpreter._switch_screen(type, info_screen_type)


func _handle_info_screen_type(info_screen_type: String) -> void:
	
	
	
	match info_screen_type:
		"NO_CELL_DETECTED":
			timer_increment._reset_timer()
		"INVALID_STAT":
			timer_increment._reset_timer()
			audio_manager.play_hidden_stat_invalid()
		"JOLT":
			timer_increment._pause_timer()

			
		"FINISHED":
			timer_increment._reset_timer()
			audio_manager.play_finished()
		_:
			push_error('invalid info screen type for hidden interpreter : ', info_screen_type)
#######################


#### INCREMENT AND FINISHED ####
func _handle_interpreter_timer_increment(current_time_increment: int) -> void:
	if current_screen == "IDLE_SCREEN" or current_screen == "GAME_SCREEN":
		screen_hidden_interpreter._handle_timer_increment(current_time_increment)

func _handle_interpreter_timer_finished() -> void:
	## UNHIDE STAT ON CELL
	GLCellManagerBus.emit_signal('hidden_stat_interpreted',
	 	active_brain_cell_container.designated_brain_cell,
		interpreter_type
	)
	active_brain_cell_container = null
	switch_screen("INFO_SCREEN", "FINISHED")

	

func _handle_interpreter_timer_reset() -> void:
	screen_hidden_interpreter._handle_timer_reset()
	
################################


#### RECEIVING CELL BODY ####
func _handle_panel_body_recieved(cell_container: CharacterBody3D) -> void:
	
	active_brain_cell_container = cell_container
	

	if not active_brain_cell_container:
		switch_screen("INFO_SCREEN", "NO_CELL_DETECTED")
		return
	
	var active_designated_brain_cell: BrainCell = active_brain_cell_container.designated_brain_cell

	if not active_designated_brain_cell:
		switch_screen("INFO_SCREEN", "NO_CELL_DETECTED")
		return

	var cell_has_valid_stat: bool = _cell_has_hidden_interpreter_stat(active_designated_brain_cell)

	## prevent during jolt
	if jolt_active :
		return

	if cell_has_valid_stat:
		switch_screen("IDLE_SCREEN")
		audio_manager.play_stat_accepted()
		audio_manager.toggle_play_idle_drone(true)
	else:
		switch_screen("INFO_SCREEN", "INVALID_STAT")


func _cell_has_hidden_interpreter_stat(brain_cell: BrainCell) -> bool:
	match interpreter_type:
		"strength":
			return brain_cell.strength.hidden

		"intelligence":
			return brain_cell.intelligence.hidden

		"community":
			return brain_cell.community.hidden

		_:
			push_error("Invalid interpreter_type: " + interpreter_type)
			return false
########################

#### CHAIR ###
func _toggle_handle_player_sat_on_chair(toggle_value : bool) :
	player_sitting_in_chair = toggle_value
	
	if player_sitting_in_chair :	
		switch_screen('GAME_SCREEN')
	
	else :
		if active_brain_cell_container :  
			switch_screen('IDLE_SCREEN')
		else :
			switch_screen('NO_CELL_DETECTED')
	
####### POINT COLLECTED FROM GAME ###
func _handle_point_collected(point_amount : int) :
	timer_increment._point_collected(point_amount)
	
#### JOLT EVENT ####
func _handle_defect_event_jolt(selected_interpreters : Array) : 
	for selected_interpreter_type : String in selected_interpreters : 
		if selected_interpreter_type == interpreter_type :
			
			switch_screen('INFO_SCREEN', 'JOLT')	
			
			jolt_particles.emitting = true
			audio_manager.toggle_play_jolt(true)
			jolt_active = true
			energy_decrease_spawner._start_spawning_decrease_particles(selected_interpreters)
			
			if active_brain_cell_container :
				active_brain_cell_container.switch_cell_state('jolt')
	
func _handle_stop_jolt_btn_pressed() :
	
	jolt_active = false
	audio_manager.toggle_play_jolt(false)
	jolt_particles.emitting = false 
	energy_decrease_spawner._stop_spawning_decrease_particles()
	
	if active_brain_cell_container : 
		switch_screen('IDLE_SCREEN')	
		if active_brain_cell_container :
			active_brain_cell_container.switch_cell_state('idle')
	else : 
		switch_screen("INFO_SCREEN", "NO_CELL_DETECTED")
