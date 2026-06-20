extends Node

var last_tier: int = 0

func _update_progression(total_points_collected: int) -> void:
	if total_points_collected >= 10:
		_set_tier_3()
	elif total_points_collected >= 5:
		_set_tier_2()
	else:
		_set_tier_1()


func _set_tier_1() -> void:
	if last_tier == 1:
		return
		
	# player ship
	IVAstroidBrain.shooting_delay_wait_time =  0.3
	IVAstroidBrain.bullet_speed = 200.0
	IVAstroidBrain.move_speed = 180.0
	IVAstroidBrain.can_spawn_bubble = false
	# astroid spawning
	IVAstroidBrain.min_astroids_to_spawn_small = 1
	IVAstroidBrain.max_astroid_to_spawn_small = 2
	IVAstroidBrain.min_astroids_to_spawn_medium = 1
	IVAstroidBrain.max_astroids_to_spawn_medium = 2
	IVAstroidBrain.astroids_to_spawn_large = 0
	# astroid misc 
	IVAstroidBrain.astroids_point_ranges = [0,2]
	IVAstroidBrain.small_astroid_speed = 50
	IVAstroidBrain.medium_astroid_speed = 30
	IVAstroidBrain.large_astroid_speed = 25
	IVAstroidBrain.smaller_break_astroids_to_spawn = 0
	IVAstroidBrain.twice_smaller_break_astroids_to_spawn = 0
	
	last_tier = 1 

func _set_tier_2() -> void:
	if last_tier == 2:
		return
		
	# player ship
	IVAstroidBrain.shooting_delay_wait_time =  0.25
	IVAstroidBrain.bullet_speed = 210.0
	IVAstroidBrain.move_speed = 200.0
	IVAstroidBrain.can_spawn_bubble = true
	# astroid spawning
	IVAstroidBrain.min_astroids_to_spawn_small = 1
	IVAstroidBrain.max_astroid_to_spawn_small = 1
	IVAstroidBrain.min_astroids_to_spawn_medium = 2
	IVAstroidBrain.max_astroids_to_spawn_medium = 2
	IVAstroidBrain.astroids_to_spawn_large = 1
	# astroid misc 
	IVAstroidBrain.astroids_point_ranges = [0, 2, 3]
	IVAstroidBrain.small_astroid_speed = 60
	IVAstroidBrain.medium_astroid_speed = 40
	IVAstroidBrain.large_astroid_speed = 25
	IVAstroidBrain.smaller_break_astroids_to_spawn = 50
	IVAstroidBrain.twice_smaller_break_astroids_to_spawn = 0
		
	last_tier = 2


func _set_tier_3() -> void:
	if last_tier == 3:
		return
	
	# player ship
	IVAstroidBrain.shooting_delay_wait_time =  0.20
	IVAstroidBrain.bullet_speed = 220.0
	IVAstroidBrain.move_speed = 220.0
	IVAstroidBrain.can_spawn_bubble = true
	# astroid spawning
	IVAstroidBrain.min_astroids_to_spawn_small = 1
	IVAstroidBrain.max_astroid_to_spawn_small = 2
	IVAstroidBrain.min_astroids_to_spawn_medium = 1
	IVAstroidBrain.max_astroids_to_spawn_medium = 2
	IVAstroidBrain.astroids_to_spawn_large = 1
	# astroid misc 
	IVAstroidBrain.astroids_point_ranges = [0, 2, 5]
	IVAstroidBrain.small_astroid_speed = 65
	IVAstroidBrain.medium_astroid_speed = 45
	IVAstroidBrain.large_astroid_speed = 30
	IVAstroidBrain.smaller_break_astroids_to_spawn = 50
	IVAstroidBrain.twice_smaller_break_astroids_to_spawn = 25

	last_tier = 3
