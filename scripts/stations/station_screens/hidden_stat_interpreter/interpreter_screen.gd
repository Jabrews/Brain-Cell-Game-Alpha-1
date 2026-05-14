extends Node

# componnets
@onready var progress_timer : Timer = $InterpreterProgressTimer
@onready var progress_bar : TextureProgressBar = $ProgressBar
@onready var time_left_label : Label = $TimeLeft
@onready var speed_up_sprite : Sprite2D = $SpeedSprite
@onready var screen_swap_handler : Node = $"../ScreenSwapHandler"
@onready var interpreter_finished_sound : AudioStreamPlayer3D = $InterpreterFinishedSound

var panel_cell : BrainCell

var total_progress : int = 0
var total_duration : int = 30
var progress_increment : int = 1


func _ready() -> void:
	progress_timer.connect('timeout', _handle_progress_timer_timeout)
	progress_bar.max_value = 30
	update_time_left_label(total_duration)
	
	
func _load_panel_cell(new_panel_cell : BrainCell) : 
	if new_panel_cell :
		progress_timer.start()	
	if not new_panel_cell :
		reset_progress()
	
	panel_cell = new_panel_cell
		
		


func _handle_progress_timer_timeout() :
	total_progress += progress_increment
	
	# update progress bar
	progress_bar.value = total_progress
	# update time left label
	update_time_left_label(total_duration - total_progress )
	
	# check if finished	
	if total_progress >= total_duration : 
		var stat_type = get_parent().interpreter_type 
		GLCellManagerBus.emit_signal('hidden_stat_interpreted', panel_cell, stat_type)
		interpreter_finished_sound.play()
		# reset progress
		reset_progress()

	
func reset_progress() :
	progress_timer.stop()
	progress_bar.value = 0
	total_progress = 0
	speed_up_sprite.visible = false
	progress_increment = 1
	panel_cell = null

func update_time_left_label(amount_left : int) :
	time_left_label.text = 'Time Left : ' + str(amount_left)
	

### SPEED UP ###
func _toggle_speed_up(toggleValue : bool) : 
	if toggleValue : 
		progress_increment = 2		
		speed_up_sprite.visible = true
	if not toggleValue :
		progress_increment = 1
		speed_up_sprite.visible = false 
################
