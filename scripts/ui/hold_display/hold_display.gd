extends Node

var active_hold_id : Variant = null

var active_hold_duration_max : float = 0.0
var active_hold_duration_increment : float = 0.0

var curr_duration_interval : float = 0.0


# components
@onready var hold_increment_timer : Timer = $HoldIncrement
@onready var update_shader : Node = $UpdateShader


func _ready() -> void:
	GLHoldingDisplayBus.connect("start_hold", _handle_start_hold)
	GLHoldingDisplayBus.connect('player_interupted_hold', _handle_player_interupted_hold)
	hold_increment_timer.connect("timeout", _handle_increment_timer_timeout)
	hold_increment_timer.one_shot = true
	

func _process(_delta: float) -> void: 
	# this happens when we let go too early
	if active_hold_id != null: 
		if Input.is_action_just_released("interact"):
			end_hold(false)


func _handle_start_hold(
	hold_max_duration : float,
	hold_duration_increment : float,
	hold_id : String
) -> void:
	
	# prevent from over-running
	if active_hold_id != null:
		return
	
	if hold_max_duration <= 0.0:
		return
	
	if hold_duration_increment <= 0.0:
		return
	
	# set active vars
	active_hold_id = hold_id
	active_hold_duration_max = hold_max_duration
	active_hold_duration_increment = hold_duration_increment
	curr_duration_interval = 0.0
	
	# start shader at 0
	update_shader._handle_increment()
	
	# increment timer till it reaches max	
	hold_increment_timer.wait_time = active_hold_duration_increment
	hold_increment_timer.start()
	
	# let player know that if they move to end
	GLHoldingDisplayBus.player_is_holding = true 


func _handle_increment_timer_timeout() -> void:
	if active_hold_id == null:
		return
	
	curr_duration_interval += active_hold_duration_increment
	curr_duration_interval = minf(curr_duration_interval, active_hold_duration_max)
	
	update_shader._handle_increment()
	
	if curr_duration_interval >= active_hold_duration_max:
		end_hold(true)
	else:
		hold_increment_timer.start()


func end_hold(is_success: bool) -> void:
	
	GLHoldingDisplayBus.player_is_holding = false	
	
	
	if active_hold_id == null:
		return
	
	hold_increment_timer.stop()
	
	# emit back to parent component
	GLHoldingDisplayBus.emit_signal("end_hold", active_hold_id, is_success)
	
	
	active_hold_id = null
	active_hold_duration_max = 0.0
	active_hold_duration_increment = 0.0
	curr_duration_interval = 0.0
	
	await get_tree().create_timer(0.3).timeout
	update_shader._handle_end()


func _handle_player_interupted_hold() :
	end_hold(false)
