extends Node

enum HIDDEN_STAT_INTERPRETER_TYPES {
	STRENGTH,
	INTELLIGENCE,
	COMMUNITY
}

@export_enum("strength", "intelligence", "community")
var interpreter_type : String = "strength"

# station state
var jolt_active : bool = false
var player_speed_up_active : bool = false
var active_container : CharacterBody3D

# components
@onready var main_screen_hidden_stat_interpreter : Node2D = $InterpreterTv/TvFrontPannel/SubViewport/MainScreenHiddenStatInterpreter
@onready var interpreter_screen : Control = $InterpreterTv/TvFrontPannel/SubViewport/MainScreenHiddenStatInterpreter/InterpreterScreen
@onready var broken_particles : GPUParticles3D = $BrokenParticles
@onready var jolt_start_sound : AudioStreamPlayer3D = $JoltStartSound
@onready var jolt_spark_sound : AudioStreamPlayer3D = $JoltSparkSound


func _ready() -> void:
	
	# spread interpreter type
	main_screen_hidden_stat_interpreter.interpreter_type = interpreter_type
	
	# allow screen to talk back to station
	main_screen_hidden_stat_interpreter.station_refrence = self
	
	# defect events
	GLDefectEventMangerBus.connect(
		'event_hidden_stat_interpreter_jolt',
		_handle_jolt
	)


func set_active_container(container : CharacterBody3D) -> void:
	active_container = container


func clear_active_container() -> void:
	active_container = null


##### JOLT #####
func _handle_jolt(selected_interpreter_names: Array) -> void:
	
	# prevent duplicate jolts
	if jolt_active:
		return
	
	# prevent jolt while player standing on panel
	if player_speed_up_active :
		return
	
	for int_name in selected_interpreter_names :
		
		if int_name == interpreter_type :
			
			# only play jolt start sound if just one interpreter 
			if len(selected_interpreter_names) == 1 : 
				jolt_start_sound.play()
				
			# always play spark
			jolt_spark_sound.play()
			
			
			start_jolt()
			return


func start_jolt() -> void:
	
	jolt_active = true
	
	# particles
	broken_particles.emitting = true
	
	# notify screen
	main_screen_hidden_stat_interpreter.enter_jolt_mode()
	
	# switch container state_handle_jolt
	if active_container :
		
		active_container.state_machine.jolt_state.stat_interpreter_stat_type = interpreter_type
		
		active_container.state_machine.switch_state(
			active_container.state_machine.State.JOLT
		)


func reset_jolt() -> void:
	
	if not jolt_active:
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	else :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
		jolt_spark_sound.stop()
		jolt_start_sound.stop()
		
	
	jolt_active = false
	
	# stop particles
	broken_particles.emitting = false
	
	# return container to idle
	if active_container :
		active_container.state_machine.switch_state(
			active_container.state_machine.State.IDLE
		)
	
	# notify screen
	main_screen_hidden_stat_interpreter.exit_jolt_mode()
#################


##### RESET BTN #####
func _handle_reset_btn() -> void:
	reset_jolt()
#####################

################## SPEED PANEL ###################
func _on_speed_up_panel_body_entered(body: Node3D) -> void:
	if body.is_in_group('player') :
		interpreter_screen._toggle_speed_up(true)
		player_speed_up_active = true

func _on_speed_up_panel_body_exited(body: Node3D) -> void:
	if body.is_in_group('player') :
		interpreter_screen._toggle_speed_up(false)
		player_speed_up_active = false
##################################################
