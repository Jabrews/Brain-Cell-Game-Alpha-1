extends Node

# componnets
@onready var bubble_scene : PackedScene = preload("res://scenes/stations/station_screens/hidden_interpreter/astroid_brain/ship/new_ship_bubble.tscn")
@onready var bubble_spawn_delay_timer : Timer = $BubbleSpawnDelay
@export var player_ship : CharacterBody2D 

func delete_bubbles() :
	for bubble : Node in get_children() :
		if bubble is not Timer :
			bubble.queue_free()

func _spawn():
	
	var proceed : bool = verify_duplicates()	
	
	if proceed : 
		
		# random timeout for delay	
		bubble_spawn_delay_timer.wait_time = randi_range(2, 8)
		bubble_spawn_delay_timer.start()	
		await bubble_spawn_delay_timer.timeout
		
		# kinda hacky
		# incase called multiple times before bubble cleared
		if not IVAstroidBrain.can_spawn_bubble :
			return
		
		var bubble_instance = bubble_scene.instantiate()	
		
		var bubble_y : float = 48.0
		var bubble_x : int = randi_range(50, 300)
		
		bubble_instance.global_position = Vector2(bubble_x, bubble_y)
		
		add_child(bubble_instance)	
		
		IVAstroidBrain.can_spawn_bubble = false
	
func verify_duplicates() :	
	if len(player_ship.handle_ship_duplicates.current_ships) >= 2 :
		return false
	else : 
		return true
	
	
	
	
	
	
	
	
	
	
