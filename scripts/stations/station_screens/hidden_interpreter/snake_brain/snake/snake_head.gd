extends CharacterBody2D

var move_dir : Vector2 = Vector2.RIGHT
var cant_move : bool = false


func _process(_delta: float) -> void:
	
	if not cant_move :
		
		var input_dir := Input.get_vector("left", "right", "up", "down")

		# only update direction if player pressed something
		if input_dir != Vector2.ZERO:
			input_dir = input_dir.normalized()
			
			# prevent reversing into yourself
			if input_dir != -move_dir:
				move_dir = input_dir

		move_head()

func _toggle_start(toggle_value : bool) :
	cant_move = toggle_value
	
	if toggle_value :
		global_position = Vector2(231.0, 141.0)
	
		
func move_head() -> void:
	velocity = move_dir * IVSnakeBrain.snake_speed
	
	move_and_slide()
	
	get_parent()._handle_snake_head_moved(0, global_position.x, global_position.y)
