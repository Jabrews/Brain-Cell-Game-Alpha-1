extends CharacterBody2D

@export var float_horizontal_distance : float = 5.0
var starting_position : Vector2

var x_move_direction : int = 1
var bubble_speed : float = 30.0

var max_wall_bumps_to_delete : int = 2
var curr_wall_bumps : int = 0

func _ready() -> void:
	starting_position = global_position
	
	vertical_float_movement()

func _process(_delta: float) -> void:
	
	velocity.x = bubble_speed * x_move_direction
	
	move_and_slide()	
	
		

	
func vertical_float_movement() :	
	var vertical_movement_tween = create_tween()
	vertical_movement_tween.set_loops()
	vertical_movement_tween.tween_property(self, 'position:y', starting_position.y + float_horizontal_distance, 1.0)
	vertical_movement_tween.tween_property(self, 'position:y', starting_position.y, 1.0)
	vertical_movement_tween.tween_property(self, 'position:y', starting_position.y - float_horizontal_distance, 1.0)
	
	
func increment_wall_bump() :
	curr_wall_bumps += 1
	
	if curr_wall_bumps >= max_wall_bumps_to_delete :	
		kill_bubble()

func kill_bubble() :
	
	set_collision_layer_value(5,0)
	
	var scale_tween = create_tween()	
	scale_tween.tween_property(self, 'scale', Vector2.ZERO, 1.0)
	await  scale_tween.finished
	queue_free()
	
	
	
	
	
	


	
	
	
