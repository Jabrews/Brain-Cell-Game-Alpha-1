extends Node

var current_time_increment : int = 0

# componnets
@onready var timer_increment : Timer = $TimerIncrement

func _ready() -> void:
	timer_increment.connect('timeout', _handle_timer_increment_timeout)
	
	GLInterpreterGames.connect('player_collected_point', _handle_player_collected_point)
	

func _start_timer() :
	
	# only start timer if its not already running
	if timer_increment.is_stopped()	 :
		timer_increment.start()	

func _pause_timer() :
	timer_increment.stop()

func _reset_timer() :
	current_time_increment = 0	
	timer_increment.stop()
	get_parent()._handle_interpreter_timer_reset()
	
func _handle_timer_increment_timeout() :
	current_time_increment += 1
	
	if current_time_increment >= IVHiddenStats.max_time_to_discover_hidden : 
		get_parent()._handle_interpreter_timer_finished()
	
	else : 
		get_parent()._handle_interpreter_timer_increment(current_time_increment)
		
	
#func _point_collected(point_value : int) :
	#current_time_increment += point_value
	#if current_time_increment >= IVHiddenStats.max_time_to_discover_hidden : 
		#get_parent()._handle_interpreter_timer_finished()
	#else : 
		#get_parent()._handle_interpreter_timer_increment(current_time_increment)

func _handle_player_collected_point(point_amount : int, interpreter_type : String) :
	if interpreter_type == get_parent().interpreter_type :
		current_time_increment += point_amount	
		
		
