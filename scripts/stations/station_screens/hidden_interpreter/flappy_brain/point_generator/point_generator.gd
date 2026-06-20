extends Node

# components
@onready var spawn_point_goal: Node = $SpawnPointGoal
@onready var get_above_tube_pos: Node = $GetAboveTubePos
@onready var get_bewteen_tube_pos: Node = $GetBewteenTubePos
@onready var get_bewteen_preloads: Node = $GetBewteenPreloads
@onready var get_extreme_bewteen_preloads: Node = $GetExtemeBewteenPreloads

var last_tube_preload_instance: Node2D


func generate_tube_points(tube_preload: Node2D) -> void:
	try_generate_above_tube_points(tube_preload)
	try_generate_bewteen_tube_point(tube_preload)
	try_generate_bewteen_preload_point(tube_preload)
	
	# Update last tube after all generation checks
	last_tube_preload_instance = tube_preload


func chance_passed(chance: int) -> bool:
	chance = clamp(chance, 0, 100)

	if chance <= 0:
		return false

	if chance >= 100:
		return true

	return randi_range(1, 100) <= chance


func try_generate_above_tube_points(tube_preload: Node2D) -> void:

	var ran_num = randi_range(0 , 100)
	if ran_num >= 50 :
		generate_above_tube_point(tube_preload, "top")
	else :
		generate_above_tube_point(tube_preload, "bottom")


func try_generate_bewteen_tube_point(tube_preload: Node2D) -> void:
	if not chance_passed(IVFlappyBrain.chance_to_generate_bewteen_tube):
		return

	generate_bewteen_tube_point(tube_preload)


func try_generate_bewteen_preload_point(tube_preload: Node2D) -> void:
	if not last_tube_preload_instance:
		return

	var normal_chance: int = IVFlappyBrain.chance_to_generate_bewteen_preload
	var extreme_chance: int = IVFlappyBrain.chance_to_generate_extreme_bewteen_preload

	var can_generate_normal := chance_passed(normal_chance)
	var can_generate_extreme := chance_passed(extreme_chance)

	if can_generate_normal and can_generate_extreme:
		if randi_range(0, 1) == 0:
			generate_bewteen_preloads(tube_preload)
		else:
			extreme_generate_bewteen_preloads(tube_preload)

	elif can_generate_normal:
		generate_bewteen_preloads(tube_preload)

	elif can_generate_extreme:
		extreme_generate_bewteen_preloads(tube_preload)


func generate_above_tube_point(tube_preload: Node2D, direction: String) -> void:
	var spawn_pos: Vector2

	if direction == "top":
		spawn_pos = get_above_tube_pos._get_pos(tube_preload, "top")
	elif direction == "bottom":
		spawn_pos = get_above_tube_pos._get_pos(tube_preload, "bottom")
	else:
		push_error("Invalid direction: " + direction)
		return

	spawn_point_goal._create_point_goal(tube_preload, spawn_pos, 3)


func generate_bewteen_tube_point(tube_preload: Node2D) -> void:
	var spawn_pos: Vector2 = get_bewteen_tube_pos._get_pos(tube_preload)
	spawn_point_goal._create_point_goal(tube_preload, spawn_pos, 2)


func generate_bewteen_preloads(tube_preload: Node2D) -> void:
	var spawn_pos: Vector2 = get_bewteen_preloads._get_pos(
		tube_preload,
		last_tube_preload_instance
	)

	spawn_point_goal._create_point_goal(tube_preload, spawn_pos, 2)


func extreme_generate_bewteen_preloads(tube_preload: Node2D) -> void:
	var spawn_pos: Vector2 = get_extreme_bewteen_preloads._get_pos(
		tube_preload,
		last_tube_preload_instance
	)

	spawn_point_goal._create_point_goal(tube_preload, spawn_pos, 5)
