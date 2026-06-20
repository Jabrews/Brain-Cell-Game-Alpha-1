extends Node


func _update_progression(total_points_collected : int) :
	
	# tier one
	if total_points_collected >= 0 :	
		IVFlappyBrain.tube_speed = 140
		IVFlappyBrain.spawn_obstacle_delay_min = 2
		IVFlappyBrain.spawn_obstacle_delay_max = 3
		IVFlappyBrain.gap_bewteen_tubes_min = 7
		IVFlappyBrain.gap_bewteen_tubes_max = 9
		IVFlappyBrain.center_y_unit_min = 2
		IVFlappyBrain.center_y_unit_max = 14
		
		IVFlappyBrain.chance_to_generate_above_tube = 50
		IVFlappyBrain.chance_to_generate_bewteen_tube = 25
		IVFlappyBrain.chance_to_generate_bewteen_preload = 25
		IVFlappyBrain.chance_to_generate_extreme_bewteen_preload = 0
		
		
	
	
	# tier two
	if total_points_collected >= 5 : 
		IVFlappyBrain.tube_speed = 150
		IVFlappyBrain.spawn_obstacle_delay_min = 1
		IVFlappyBrain.spawn_obstacle_delay_max = 3
		IVFlappyBrain.gap_bewteen_tubes_min = 6
		IVFlappyBrain.gap_bewteen_tubes_max = 7
		IVFlappyBrain.center_y_unit_min = 4
		IVFlappyBrain.center_y_unit_max = 12
		
		IVFlappyBrain.chance_to_generate_above_tube = 20
		IVFlappyBrain.chance_to_generate_bewteen_tube = 20
		IVFlappyBrain.chance_to_generate_bewteen_preload = 30
		IVFlappyBrain.chance_to_generate_extreme_bewteen_preload = 30

	if total_points_collected >= 10 :
		IVFlappyBrain.tube_speed = 175
		IVFlappyBrain.spawn_obstacle_delay_min = 1
		IVFlappyBrain.spawn_obstacle_delay_max = 2
		IVFlappyBrain.gap_bewteen_tubes_min = 5
		IVFlappyBrain.gap_bewteen_tubes_max = 6
		IVFlappyBrain.center_y_unit_min = 6
		IVFlappyBrain.center_y_unit_max = 10
		
		IVFlappyBrain.chance_to_generate_above_tube = 0
		IVFlappyBrain.chance_to_generate_bewteen_tube = 20
		IVFlappyBrain.chance_to_generate_bewteen_preload = 40
		IVFlappyBrain.chance_to_generate_extreme_bewteen_preload = 40

		
