extends Node

# componnets
@onready var loading_wall_scene : PackedScene = preload("res://scenes/stations/station_screens/hidden_interpreter/snake_brain/wall/loading_wall.tscn")
@onready var wall_parent_node : Node = $Walls
@onready var spawn_wall_delay_timer : Timer = $SpawnWallDelay
@onready var find_valid_spawn_point : Node = $"../FindValidSpawnPoint"

func _ready() -> void:
	spawn_wall_delay_timer.connect('timeout', _handle_spawn_wall)
		

func _handle_create_walls() :
	for wall : Node2D in wall_parent_node.get_children() :
		wall.queue_free()
	
	spawn_wall_delay_timer.start()

func _handle_stop_creating_wall() :
	spawn_wall_delay_timer.stop()
	
	for wall : Node2D in wall_parent_node.get_children() :
		wall.queue_free()
	
	

	
func _handle_spawn_wall() -> void:
	var wall_count: int = 1
	
	if IVSnakeBrain.spawn_two_walls:
		wall_count = 2
	
	for i in wall_count:
		var loading_wall_instance: Node2D = loading_wall_scene.instantiate()
		var spawn_pos: Vector2 = await find_valid_spawn_point.find()
		
		loading_wall_instance.global_position = spawn_pos
		wall_parent_node.add_child(loading_wall_instance)
	
	
	
		
	
	
