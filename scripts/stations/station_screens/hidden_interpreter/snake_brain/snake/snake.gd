extends Node

var snake_parts : Array[Coord] = [
	Coord.new(231.0, 141.0)
]
var snake_body_nodes : Array[Node2D] = []

var curr_body_i = 1

## DEBUG 
var body_spacing : float = 12.0

# components
@onready var snake_head_scene : PackedScene = preload("res://scenes/stations/station_screens/hidden_interpreter/snake_brain/snake/snake_head.tscn")
@onready var snake_body_scene : PackedScene = preload("res://scenes/stations/station_screens/hidden_interpreter/snake_brain/snake/snake_body.tscn")


func _ready() -> void:
	#add_head_to_nodeas()
	GLInterpreterGames.connect('snake_collected_point', _handle_point_collected)

func _handle_snake_head_moved(index : int, new_x : float, new_y : float) -> void:
	if index != 0:
		return
	
	if snake_parts.is_empty():
		return
	
	# save old positions before changing head position
	var old_positions : Array[Coord] = []
	
	for part : Coord in snake_parts:
		old_positions.append(Coord.new(part.x, part.y))
	
	# update head stored position
	snake_parts[0].x = new_x
	snake_parts[0].y = new_y
	
	await get_tree().create_timer(0.13).timeout
	
	# move each body part into the old position of the part before it
	for i in range(1, snake_parts.size()):
		var target_position : Coord = old_positions[i - 1]
		
		snake_parts[i].x = target_position.x
		snake_parts[i].y = target_position.y
		
		var body_node : Node2D = snake_body_nodes[i - 1]  # -1 because we dont include head
		body_node._move_body(target_position)


	
func create_body() -> void :
	var body_instance : StaticBody2D = snake_body_scene.instantiate()
	
	#body_instance.global_position = Vector2(0.0, body_spacing * curr_body_i)
	add_child(body_instance)
	
	body_instance.name = "SnakeBody" + str(curr_body_i)
	body_instance._load(curr_body_i)
	
	snake_body_nodes.append(body_instance)
	snake_parts.append(Coord.new(body_instance.global_position.x, body_instance.global_position.y))

func _reset_snake_body() -> void:
	# delete every body node
	for snake_body: Node2D in get_children():
		if not snake_body is CharacterBody2D:
			snake_body.queue_free()
		
	# reset each part other than head
	while snake_parts.size() > 1:
		snake_parts.remove_at(1)	
	
	snake_body_nodes = []
	
	

func _handle_point_collected(_point_amount : int) :
	create_body()
