extends Node

# components
@onready var astroid_scene: PackedScene = preload("res://scenes/stations/station_screens/hidden_interpreter/astroid_brain/astroid/astroid.tscn")
@onready var astroid_parent_node: Node = $Astroids
@onready var left_spawn_spot: Node2D = $LeftSpot
@onready var right_spawn_spot: Node2D = $RightSpot
@onready var bubble_spawner : Node = $"../BubbleSpawner"

var current_astroids: int = 0
var waiting_for_next_batch: bool = false


func _ready() -> void:
	GLInterpreterGames.connect("astroid_killed", _handle_astroid_killed)

func toggle_start(toggleValue : bool) :
	if toggleValue :
		await get_tree().create_timer(0.5).timeout 
		current_astroids = 0
		waiting_for_next_batch = false
		generate_next_astroid_batch()
	else : 
		for astroid : Node2D in astroid_parent_node.get_children(): 
			astroid.queue_free()
		current_astroids = 0

func _handle_astroid_killed() -> void:
	current_astroids -= 1
	current_astroids = max(current_astroids, 0)

	if current_astroids == 0 and not waiting_for_next_batch:
		waiting_for_next_batch = true

		await get_tree().create_timer(1.0).timeout

		generate_next_astroid_batch()
		
		handle_spawn_bubble()
		
		waiting_for_next_batch = false


func generate_next_astroid_batch() -> void:
	var small_astroids_to_create: int = randi_range(
		IVAstroidBrain.min_astroids_to_spawn_small,
		IVAstroidBrain.max_astroid_to_spawn_small
	)

	var medium_astroids_to_create: int = randi_range(
		IVAstroidBrain.min_astroids_to_spawn_medium,
		IVAstroidBrain.max_astroids_to_spawn_medium
	)

	var large_astroids_to_create: int = IVAstroidBrain.astroids_to_spawn_large

	current_astroids = small_astroids_to_create + medium_astroids_to_create + large_astroids_to_create

	for i in range(small_astroids_to_create):
		create_astroid("small")

	for i in range(medium_astroids_to_create):
		create_astroid("medium")

	for i in range(large_astroids_to_create):
		create_astroid("large")


func create_astroid(type: String) -> void:
	var astroid_instance: CharacterBody2D = astroid_scene.instantiate()

	match type:
		"small":
			astroid_instance.health = 2
			astroid_instance.points = get_random_astroid_points()

		"medium":
			astroid_instance.health = 4
			astroid_instance.points = get_random_astroid_points()

		"large":
			astroid_instance.health = 5
			astroid_instance.points = get_random_astroid_points()

			var ran_num: int = randi_range(0, 100)
			if ran_num <= IVAstroidBrain.smaller_break_astroids_to_spawn:
				astroid_instance.can_break_into_smaller = true

		_:
			push_error("Invalid astroid type: " + type)
			return

	spawn_astroid(astroid_instance)


func get_random_astroid_points() -> int:
	return IVAstroidBrain.astroids_point_ranges.pick_random()


func spawn_astroid(astroid_instance: CharacterBody2D) -> void:
	var spawn_spot: Node2D

	var ran_num: int = randi_range(0, 100)

	if ran_num >= 50:
		spawn_spot = left_spawn_spot
	else:
		spawn_spot = right_spawn_spot

	# How much the asteroid can spawn above/below the spawn spot
	var x_spawn_randomness: float = 20.0

	var random_x_offset: float = randf_range(
		-x_spawn_randomness,
		x_spawn_randomness,
	)

	var spawn_position: Vector2 = Vector2(
		spawn_spot.global_position.x + random_x_offset,
		spawn_spot.global_position.y
	)

	astroid_instance.global_position = spawn_position

	astroid_parent_node.add_child(astroid_instance)
	
	
func handle_spawn_bubble() :
	
	if IVAstroidBrain.can_spawn_bubble :
		
		var random_num = randi_range(0, 100)
		
		if random_num <= 99 :
			bubble_spawner._spawn()
		else :
			return
			
			
			
		
		
	
	
