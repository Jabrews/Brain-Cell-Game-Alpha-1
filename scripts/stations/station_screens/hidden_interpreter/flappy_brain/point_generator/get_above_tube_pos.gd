
extends Node


func _get_pos(tube_preload: Node2D, tube_type: String) -> Vector2:
	var tube: StaticBody2D
	
	if tube_type == "top":
		tube = tube_preload.get_child(1)
	elif tube_type == "bottom":
		tube = tube_preload.get_child(0)
	else:
		push_error("Invalid tube_type: " + tube_type)
		return Vector2.ZERO
	
	var collision: CollisionShape2D = tube.get_node("CollisionShape2D")
	
	var x_pos: float = collision.global_position.x - 5.0
	var y_pos: float
	
	if tube_type == "top":
		# For the top tube, you usually want the bottom edge
		y_pos = get_tube_bottom_y(tube) + 21.0
	else:
		# For the bottom tube, you usually want the top edge
		y_pos = get_tube_top_y(tube) - 27.0
	
	return Vector2(x_pos, y_pos)


func get_tube_top_y(tube: StaticBody2D) -> float:
	var collision: CollisionShape2D = tube.get_node_or_null("CollisionShape2D")
	
	if not collision:
		push_error(tube.name + " has no CollisionShape2D child.")
		return tube.global_position.y
	
	var rect_shape := collision.shape as RectangleShape2D
	
	if not rect_shape:
		push_error(tube.name + "'s collision shape is not a RectangleShape2D.")
		return collision.global_position.y
	
	var half_height = rect_shape.size.y * abs(collision.global_scale.y) / 2.0
	
	return collision.global_position.y - half_height


func get_tube_bottom_y(tube: StaticBody2D) -> float:
	var collision: CollisionShape2D = tube.get_node_or_null("CollisionShape2D")
	
	if not collision:
		push_error(tube.name + " has no CollisionShape2D child.")
		return tube.global_position.y
	
	var rect_shape := collision.shape as RectangleShape2D
	
	if not rect_shape:
		push_error(tube.name + "'s collision shape is not a RectangleShape2D.")
		return collision.global_position.y
	
	var half_height = rect_shape.size.y * abs(collision.global_scale.y) / 2.0
	
	return collision.global_position.y + half_height
