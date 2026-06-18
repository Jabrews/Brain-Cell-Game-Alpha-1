extends Node

var total_points_collected = 0
var start_screen_active : bool = true

# componnets
@onready var progression_manager : Node = $ProgressionManager
@onready var game_screen_timer : Node2D = $GameScreenTimer
@onready var obstacle_manager : Node = $ObstacleManager
@onready var start_screen_graphic : Node = $StartScreenGraphic
@onready var brain : CharacterBody2D = $Brain
@onready var tube_spawner : Node2D = $TubeSpawner




func _ready() -> void:
	GLInterpreterGames.connect('brain_hit_kill_area', _handle_brain_hit_kill_area)
	GLInterpreterGames.connect('brain_collected_points', _handle_brain_collected_points)
	
	progression_manager._update_progression(total_points_collected)
	
	# load start screen	
	toggle_start_screen(true)	
	
	
func _process(_delta: float) -> void: 
	if start_screen_active : 
		if Input.is_action_just_pressed('jump') :
			toggle_start_screen(false)
	
	
func toggle_start_screen(toggle_value :bool) :
	start_screen_active = toggle_value
	start_screen_graphic.toggle_start(toggle_value)
	brain.toggle_idle_float(toggle_value)
	obstacle_manager.start_obstacle_manager(toggle_value)


### EVENTS ###
	
func _handle_brain_hit_kill_area() :
	
	# freeze every tube
	# make rotate 90 and make player fall
	# wait 3 seconds
	
	# play death first then
	brain.reset()
	toggle_start_screen(true)
	total_points_collected = 0
	progression_manager._update_progression(total_points_collected)
	for tube : Node2D in tube_spawner.get_children() :
		tube.queue_free()
	
	
	
	
func _handle_increment(current_time_increment : int) :
	game_screen_timer.call_deferred("_handle_increment", current_time_increment)
	
func _handle_brain_collected_points(point_amount) :
	print('point collected')
	total_points_collected += point_amount
	progression_manager._update_progression(total_points_collected)
	game_screen_timer.call_deferred("_handle_point_collected", point_amount)
