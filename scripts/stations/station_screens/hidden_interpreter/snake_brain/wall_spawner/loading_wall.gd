extends Node2D

@onready var time_left_label : Label = $TimeLeftLabel
@onready var anim_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var wall_scene : PackedScene = preload("res://scenes/stations/station_screens/hidden_interpreter/snake_brain/wall/wall.tscn")



var max_time : float = 0.0
var time_left : float = 0.0
var is_counting_down : bool = false


func _ready() -> void:
	anim_sprite.sprite_frames.set_animation_speed("default", IVSnakeBrain.wall_loading_time_to_place)
	
	start_countdown_from_animation()
	
func _process(delta: float) -> void:
	if not is_counting_down:
		return
	
	time_left -= delta
	time_left = maxf(time_left, 0.0)
	
	time_left_label.text = str(ceili(time_left))
	
	if time_left <= 0.0:
		is_counting_down = false
		time_left_label.text = "0"
		create_wall()


func start_countdown_from_animation() -> void:
	var anim_name : StringName = anim_sprite.animation
	
	var frame_count : int = anim_sprite.sprite_frames.get_frame_count(anim_name)
	var fps : float = anim_sprite.sprite_frames.get_animation_speed(anim_name)
	
	if fps <= 0.0:
		time_left_label.text = "0"
		return
	
	max_time = float(frame_count) / fps
	time_left = max_time
	
	time_left_label.text = str(ceili(time_left))
	is_counting_down = true
	
	anim_sprite.play()

func create_wall() :
	var wall_instance : Node2D = wall_scene.instantiate()
	wall_instance.global_position = global_position	
	wall_instance.scale = randomize_wall_scale()
	get_parent().add_child(wall_instance)
	queue_free()
	

func randomize_wall_scale() :
	
	if IVSnakeBrain.create_only_big_walls :	
		return Vector2(2.0, 2.0)
	
	elif IVSnakeBrain.create_only_small_walls  :
		return Vector2(1.0, 1.0)
	
	else :
	
		var random_scale = Vector2(2.0, 2.0)
		var random_num = randi_range(0, 100)
		if random_num >= 50 :
			random_scale = Vector2(1, 1)
		
		return random_scale
	
	
	
