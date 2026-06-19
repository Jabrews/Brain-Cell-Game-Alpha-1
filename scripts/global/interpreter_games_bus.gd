extends Node

# flappy brain
signal brain_hit_kill_area()
signal brain_collected_points(point_amount : int)

# snake brain
signal snake_hit_kill_area() 
signal snake_collected_point(point_amount : int)
signal snake_point_retry(point_amount : int)
signal snake_spawn_second_point()

# astroid brain
signal ship_collected_point(point_amount : int)
signal ship_collected_bubble()
signal parent_ship_died()
signal child_ship_died(ship_instance : CharacterBody2D)
signal astroid_killed()



signal player_collected_point(amount : int, interpreter_type : String)
