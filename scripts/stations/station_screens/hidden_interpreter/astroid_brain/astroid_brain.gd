extends Node

# componnets 
@onready var game_screen_timer : Node2D =  $GameScreenTimer
@onready var progression_manager : Node = $ProgressionManager
@onready var start_screen_graphic : Node2D = $StartScreenGraphic
@onready var astroid_spawner : Node = $AstroidSpawner
@onready var bubble_spawner : Node = $BubbleSpawner
@onready var player_ship : CharacterBody2D = $Ship

var total_points_collected : int = 0

var start_screen_active : bool = true


func _ready() -> void:
	GLInterpreterGames.connect('ship_collected_point', _handle_ship_collected_point)
	GLInterpreterGames.connect('parent_ship_died', _handle_parent_ship_died)
	
	progression_manager._update_progression(total_points_collected)
	
	toggle_start_screen(true)


func _process(_delta: float) -> void:
	if start_screen_active :
		if Input.is_action_just_pressed('jump')	:
			toggle_start_screen(false)
		
		var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down")
		if input_dir != Vector2.ZERO :
			toggle_start_screen(false)
			
	

func toggle_start_screen(toggle_value : bool) : 
	
	start_screen_active = toggle_value
	
	start_screen_graphic.toggle_start(toggle_value)
	astroid_spawner.toggle_start(!toggle_value)
	player_ship.toggle_start(!toggle_value)
	
	
	if toggle_value :
		bubble_spawner.delete_bubbles()


	

func _handle_increment(current_time_increment : int) :
	game_screen_timer.call_deferred("_handle_increment", current_time_increment)

func _handle_ship_collected_point(point_amount : int) :
	
	if point_amount == 0 :
		return
	
	total_points_collected += point_amount
	game_screen_timer.call_deferred("_handle_point_collected", point_amount)
	progression_manager._update_progression(total_points_collected)

func _handle_parent_ship_died() : 
	total_points_collected = 0
	progression_manager._update_progression(total_points_collected)
	toggle_start_screen(true)
