extends Node


# atroid base
var large_astroid_speed : float = 25
var medium_astroid_speed : float = 40
var small_astroid_speed : float = 60
var smaller_break_astroids_to_spawn : int = 25
var twice_smaller_break_astroids_to_spawn = 0


# astroid spawner
var min_astroids_to_spawn_small : int = 1
var max_astroid_to_spawn_small : int = 3
var min_astroids_to_spawn_medium  : int = 1
var max_astroids_to_spawn_medium  : int = 2
var astroids_to_spawn_large : int = 0
var astroids_point_ranges = [0, 2, 3, 5]

# bubble / duplicate ships
var can_spawn_bubble : bool = true 

# ship
var shooting_delay_wait_time : float = 0.2
var bullet_speed : float = 200.0
var move_speed : float = 200.0
