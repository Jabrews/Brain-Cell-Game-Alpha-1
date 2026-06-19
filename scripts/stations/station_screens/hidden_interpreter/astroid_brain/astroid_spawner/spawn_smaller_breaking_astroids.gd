extends Node

# components
@onready var astroid_scene : PackedScene = preload("res://scenes/stations/station_screens/hidden_interpreter/astroid_brain/astroid/astroid.tscn")

func _spawn(max_health : int, global_pos : Vector2) :
	
	var smaller_astroid_health: int = 0
	var astroids_to_create: int = IVAstroidBrain.smaller_break_astroids_to_spawn
	
	# large asteroid creates medium asteroids
	if max_health > 4:
		smaller_astroid_health = 3
	
	# medium asteroid creates small asteroids
	elif max_health > 2 and max_health <= 4:
		smaller_astroid_health = 2
	
	# small asteroids should not break anymore
	else:
		return
	
	for i in astroids_to_create:
		var astroid_instance: CharacterBody2D = astroid_scene.instantiate()
		
		astroid_instance.health = smaller_astroid_health
		
		# progression will allow medium astroid to break again into even smaller ones.
		var ran_num = randi_range(0, 100)
		if ran_num < IVAstroidBrain.twice_smaller_break_astroids_to_spawn:
			astroid_instance.can_break_into_smaller = smaller_astroid_health > 2
		
		get_parent().get_parent().call_deferred("add_child", astroid_instance)		
		
		# spawn near current asteroid, but not exactly on top
		var random_offset := Vector2(
			randf_range(-20.0, 20.0),
			randf_range(-20.0, 20.0)
		)
		
		astroid_instance.global_position = global_pos + random_offset
