extends Node

@onready var top_left : Node2D =  $TopLeft
@onready var bottom_right : Node2D = $BottomRight

@onready var detect_coll_object_scene : PackedScene = preload("res://scenes/stations/station_screens/hidden_interpreter/snake_brain/detect_collision_object.tscn")

@export var max_attempts : int = 50


func find() -> Vector2:
	var top_left_spawn_area_pos : Vector2 = top_left.global_position
	var bottom_right_spawn_area_pos : Vector2 = bottom_right.global_position
	
	for i in range(max_attempts):
		var random_x_pos : float = randf_range(
			top_left_spawn_area_pos.x,
			bottom_right_spawn_area_pos.x
		)
		
		var random_y_pos : float = randf_range(
			top_left_spawn_area_pos.y,
			bottom_right_spawn_area_pos.y
		)
		
		var spawn_pos := Vector2(random_x_pos, random_y_pos)
		
		var valid_position : bool = await test_detect_collision_object(spawn_pos)
		
		if valid_position:
			return spawn_pos
	
	push_warning("Could not find valid spawn point.")
	return top_left.global_position


func test_detect_collision_object(spawn_pos : Vector2) -> bool:
	
	
	var detect_coll_obj : Node2D = detect_coll_object_scene.instantiate()
	add_child(detect_coll_obj)
	detect_coll_obj.global_position = spawn_pos
	
	await get_tree().physics_frame
	
	var valid_position : bool = await detect_coll_obj._detect_overlap()
	
	await get_tree().create_timer(1).timeout	
	
	detect_coll_obj.queue_free()
	
	return valid_position
