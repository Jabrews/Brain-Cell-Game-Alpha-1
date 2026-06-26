extends ColorRect

@export var symbol_sprite: Sprite2D 
@export var display_parent : Node2D 

var sprite_shake_tween : Tween
var sprite_is_shaking : bool = false
@export var background_type : String 


@onready var arrow_scene : PackedScene = preload("res://scenes/stations/station_screens/prisoner_profiler_screens/Arrow.tscn" )
var saved_arrow_instance : Sprite2D



func _ready() -> void:
	GLPrisonerProfilerComponentsBus.connect('station_feedback_requested', _handle_feed_back_requested)


func _place_sprite(direction : String) -> void:
	
	if size.x == 0.0:
		symbol_sprite.visible = false 
		
	else:
		
		symbol_sprite.visible = true 
		var rect_middle: Vector2 = global_position + size / 2.0
		symbol_sprite.global_position = rect_middle
		
		create_arrow(direction)		
		


func _reset() :
	size.x = 0.0
	position.x = 0.0
	symbol_sprite.visible = false
	if saved_arrow_instance:
		saved_arrow_instance.queue_free()


func _handle_feed_back_requested(type: String, data: Dictionary) -> void:
	if type != "spare_icon":
		return
	
	var icon_type: String = data["data"]["icon_type"]
	var stat_type: String = data["data"]["stat_type"]
	
	if icon_type != background_type:
		return
	
	if stat_type != display_parent.selected_stat_type:
		return
	
	shake_sprite()
	

func shake_sprite() -> void:
	if sprite_is_shaking:
		return
	
	sprite_is_shaking =  true
	
	var starting_position : Vector2 = symbol_sprite.position
	
	sprite_shake_tween = create_tween()
	
	var shake_amount : float = 6.0
	var shake_speed : float = 0.04
	
	# Shake 3 times
	for i in range(3):
		sprite_shake_tween.tween_property(
			symbol_sprite,
			"position",
			starting_position + Vector2(shake_amount, 0),
			shake_speed
		)
		
		sprite_shake_tween.tween_property(
			symbol_sprite,
			"position",
			starting_position + Vector2(-shake_amount, 0),
			shake_speed
		)
	
	# Always return to where it started before THIS shake
	sprite_shake_tween.tween_property(
		symbol_sprite,
		"position",
		starting_position,
		shake_speed
	)
	
	sprite_shake_tween.finished.connect(func():
		symbol_sprite.position = starting_position
		sprite_is_shaking = false
	)
	
func create_arrow(direction : String) :
	saved_arrow_instance = arrow_scene.instantiate()
	saved_arrow_instance.arrow_type = direction
	saved_arrow_instance.global_position = symbol_sprite.global_position
	saved_arrow_instance.global_position.y -= 30
	saved_arrow_instance.global_position.x += 30
	get_parent().add_child(saved_arrow_instance)
		
	
	
