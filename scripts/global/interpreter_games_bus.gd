extends Node

signal brain_hit_kill_area()
signal brain_collected_points(point_amount : int)

signal snake_hit_kill_area() 
signal snake_collected_point(point_amount : int)
signal snake_point_retry(point_amount : int)
signal snake_spawn_second_point()

signal player_collected_point(amount : int, interpreter_type : String)
