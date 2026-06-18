extends Node

# componnets
@onready var game_screen_timer : Node2D = $GameScreenTimer
@onready var start_screen_graphic: Node2D = $StartScreenGraphic
@onready var snake_head : CharacterBody2D = $SnakeManager/SnakeHead
@onready var point_spawner : Node = $PointSpawner
@onready var wall_spawner : Node = $WallSpawner
@onready var snake_manager: Node = $SnakeManager
@onready var progression_manager : Node = $ProgressionManager

var start_screen_active := false

var current_points : int = 0 


func _ready() -> void:
	GLInterpreterGames.connect('snake_hit_kill_area', _handle_snake_hit_kill_area)
	GLInterpreterGames.connect('snake_collected_point', _handle_snake_collected_point)
	
	progression_manager._update_progression(current_points)
	toggle_start_screen(true)

func _process(_delta: float) -> void:
	if start_screen_active:
		var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
		
		if input_dir != Vector2.ZERO:
			toggle_start_screen(false)

	
func toggle_start_screen(toggle_value :bool) :
	start_screen_active = toggle_value
	start_screen_graphic.toggle_start(toggle_value)
	snake_head._toggle_start(toggle_value)
	
	# ON RESET
	if toggle_value : 
		print('delete stuff')
		point_spawner._handle_delete_points()
		wall_spawner._handle_stop_creating_wall()
		snake_manager._reset_snake_body()
	# START
	else : 
		point_spawner._handle_create_points()
		wall_spawner._handle_create_walls()
		print('start stuff')
		

func _handle_snake_hit_kill_area() :
	toggle_start_screen(true)	
	current_points = 0
	progression_manager._update_progression(current_points)

	
func _handle_snake_collected_point(point_amount : int) :
	game_screen_timer.call_deferred("_handle_point_collected", point_amount)
	current_points += point_amount
	progression_manager._update_progression(current_points)
	

func _handle_increment(current_time_increment : int) :
	game_screen_timer.call_deferred("_handle_increment", current_time_increment)
