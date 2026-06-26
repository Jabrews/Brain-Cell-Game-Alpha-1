extends ColorRect

@export var symbol_sprite: Sprite2D 
@export var display_parent : Node2D 

var sprite_shake_tween : Tween
var sprite_is_shaking : bool = false
@export var background_type : String 


func _ready() -> void:
	GLPrisonerProfilerComponentsBus.connect('station_feedback_requested', _handle_feed_back_requested)


func _place_sprite() -> void:
	
	#if size.x <= 10.0:
	if size.x <= 10.0 	 :
		symbol_sprite.visible = false 
		visible = false
	else:
		symbol_sprite.visible = true 
		visible = true
		var rect_middle: Vector2 = global_position + size / 2.0
		symbol_sprite.global_position = rect_middle


func _handle_feed_back_requested(type : String, data : Dictionary) -> void:
	
	match type : 	
		'shake_lock' :
			if background_type == 'lock' :
				if data['stat_type'] != display_parent.selected_stat_type:
					return
				else : 
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
