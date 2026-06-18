extends Node

@onready var point_scene : PackedScene = preload("res://scenes/stations/station_screens/hidden_interpreter/snake_brain/Point.tscn")

@onready var points_parent_node : Node = $Points
@onready var find_valid_spawn_point : Node  = $"../FindValidSpawnPoint"


func _ready() -> void:
	GLInterpreterGames.connect('snake_collected_point', _handle_snake_collected_point)
	GLInterpreterGames.connect('snake_point_retry', _handle_snake_point_retry)
	GLInterpreterGames.connect('snake_spawn_second_point', _handle_spawn_second_point)
	

func _handle_create_points() :
	# kinda hacky but on startup can have a point left over
	for point in points_parent_node.get_children() :
		point.queue_free()
	await get_tree().create_timer(0.5).timeout
	for point in points_parent_node.get_children() :
		point.queue_free()
		
	
	
	create_point()

func _handle_spawn_second_point() :
	create_point()

func _handle_delete_points() :
	for point : Node2D in points_parent_node.get_children() :
		point.queue_free()


func _handle_snake_collected_point(_point_amount : int) :
	# TODO create multiple points with progression
	create_point()

func create_point(point_amount : Variant = null) -> void:
	var point_instance : StaticBody2D = point_scene.instantiate()
	var spawn_point : Vector2 = await find_valid_spawn_point.find()
	point_instance.visible = false
	point_instance.global_position = spawn_point
	if not point_amount :
		point_instance.point_amount = get_point_amount()
	else :
		point_instance.point_amount  = point_amount
	points_parent_node.add_child(point_instance)
	point_instance.visible = true 
	
func get_point_amount() :
	return IVSnakeBrain.avaible_point_tiers.pick_random()
	
func _handle_snake_point_retry(point_amount : int ) : 
	create_point(point_amount)
	
	
