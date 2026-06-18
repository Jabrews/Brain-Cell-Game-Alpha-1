extends Node

# components
@onready var time_left_label: Label = $TimeLeft
@onready var spawn_positions: Node2D = $SpawnPositions

@export var falling_label_scene: PackedScene

var time_left_tween: Tween


func _handle_increment(current_value: int) -> void:
	var time_left = IVHiddenStats.max_time_to_discover_hidden - current_value
	time_left_label.text = str(time_left)


func _handle_point_collected(point_amount: int) -> void:
	GLInterpreterGames.emit_signal('player_collected_point', point_amount, get_parent().get_parent().parent_station_interpreter.interpreter_type)
	create_falling_label(point_amount)
	animate_time_left_label()
	
	


func create_falling_label(point_amount: int) -> void:
	var instance: RigidBody2D = falling_label_scene.instantiate()
	instance.name = "FallingLabel"

	add_child(instance)

	var spawn_pos: Marker2D = get_random_spawn_pos()
	instance.global_position = spawn_pos.global_position

	instance.load_text(point_amount)


func animate_time_left_label() -> void:
	if time_left_tween:
		time_left_tween.kill()

	time_left_label.modulate = Color.RED
	time_left_label.scale = Vector2(1.15, 1.15)

	time_left_tween = create_tween()
	time_left_tween.set_parallel(true)

	time_left_tween.tween_property(
		time_left_label,
		"modulate",
		Color.WHITE,
		0.2
	)

	time_left_tween.tween_property(
		time_left_label,
		"scale",
		Vector2.ONE,
		0.2
	)
	
func get_random_spawn_pos() -> Marker2D:
	var spawn_points: Array[Node] = spawn_positions.get_children()
	
	if spawn_points.is_empty():
		push_error("No spawn positions found.")
		return null
	
	var picked_node: Node = spawn_points.pick_random()
	
	if not picked_node is Marker2D:
		push_error(picked_node.name + " is not a Marker2D.")
		return null
	
	return picked_node as Marker2D
