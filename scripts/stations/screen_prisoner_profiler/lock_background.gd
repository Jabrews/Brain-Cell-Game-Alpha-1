extends ColorRect

@onready var locked_sprite : Sprite2D = $"../LockedSprite"
@onready var display_parent : Node2D = $"../../.."

var lock_shake_tween : Tween
var lock_is_shaking : bool = false


func _ready() -> void:
	GLPrisonerProfilerComponentsBus.connect('station_feedback_requested', _handle_feed_back_requested)


func _place_sprite() -> void:
	if size.x == 0.0:
		locked_sprite.visible = false 
	else:
		locked_sprite.visible = true 
		var rect_middle: Vector2 = global_position + size / 2.0
		locked_sprite.global_position = rect_middle


func _handle_feed_back_requested(type : String, data : Dictionary) -> void:
	if type != 'shake_lock':
		return
	
	if not data.has('stat_type'):
		return
	
	if data['stat_type'] != display_parent.selected_stat_type:
		return
	
	shake_locked_sprite()


func shake_locked_sprite() -> void:
	if lock_is_shaking:
		return
	
	lock_is_shaking = true
	
	var starting_position : Vector2 = locked_sprite.position
	
	lock_shake_tween = create_tween()
	
	var shake_amount : float = 6.0
	var shake_speed : float = 0.04
	
	# Shake 3 times
	for i in range(3):
		lock_shake_tween.tween_property(
			locked_sprite,
			"position",
			starting_position + Vector2(shake_amount, 0),
			shake_speed
		)
		
		lock_shake_tween.tween_property(
			locked_sprite,
			"position",
			starting_position + Vector2(-shake_amount, 0),
			shake_speed
		)
	
	# Always return to where it started before THIS shake
	lock_shake_tween.tween_property(
		locked_sprite,
		"position",
		starting_position,
		shake_speed
	)
	
	lock_shake_tween.finished.connect(func():
		locked_sprite.position = starting_position
		lock_is_shaking = false
	)
