extends Node

# componnets
@onready var ship_duplicate_scene : PackedScene = preload("res://scenes/stations/station_screens/hidden_interpreter/astroid_brain/ship/ship_duplicate.tscn")
@onready var ship_parent : CharacterBody2D = $".."
@onready var ship_duplicates_parent_node : Node2D = $"../ShipDuplicates"

var current_ships : Array[CharacterBody2D] = []


func _ready() -> void:
	GLInterpreterGames.connect('ship_collected_bubble', _handle_ship_collected_bubble)
	GLInterpreterGames.connect('child_ship_died', _handle_child_ship_died)

func _handle_ship_collected_bubble() -> void:
	call_deferred("create_ship")

func create_ship() -> void:
	var ship_instance: CharacterBody2D = ship_duplicate_scene.instantiate()
	ship_duplicates_parent_node.add_child(ship_instance)

	var spacing: float = 15.5
	var ship_y_position: float = ship_parent.global_position.y

	# current_ships.size() is how many duplicate ships already exist
	var ship_number: int = current_ships.size() + 1

	var distance_index: int = ceili(float(ship_number) / 2.0)

	# odd ships go right, even ships go left
	var direction: int = 1
	if ship_number % 2 == 0:
		direction = -1

	var ship_x_position: float = ship_parent.global_position.x + spacing * distance_index * direction

	ship_instance.global_position = Vector2(ship_x_position, ship_y_position)

	current_ships.append(ship_instance)

func _shoot() :		
	for ship : CharacterBody2D in current_ships :		
		ship._shoot()
	
	
func _handle_child_ship_died(ship_child_instance : CharacterBody2D) :
	for ship : CharacterBody2D in current_ships :
		if ship == ship_child_instance : 
			current_ships.erase(ship)
	
	
	
	
	
