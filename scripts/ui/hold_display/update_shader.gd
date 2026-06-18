extends Node

# components
@onready var parent_hold_display : Sprite2D = $".."

var progress_tween : Tween


func _ready() -> void:
	parent_hold_display.material = parent_hold_display.material.duplicate()
	parent_hold_display.material.set_shader_parameter("progress", 0.0)
	parent_hold_display.visible = false


func _handle_increment() -> void:
	parent_hold_display.visible = true 
	
	# get vars from parent
	var curr_value : float = get_parent().curr_duration_interval 
	var max_value : float = get_parent().active_hold_duration_max 
	
	if max_value <= 0.0:
		_set_progress(0.0)
		return
	
	var progress_num : float = curr_value / max_value
	progress_num = clampf(progress_num, 0.0, 1.0)
	
	if progress_tween:
		progress_tween.kill()
	
	progress_tween = create_tween()
	progress_tween.tween_property(
		parent_hold_display.material,
		"shader_parameter/progress",
		progress_num,
		0.12
	)


func _handle_end() -> void:
	if progress_tween:
		progress_tween.kill()
	
	_set_progress(0.0)
	parent_hold_display.visible = false


func _set_progress(value : float) -> void:
	parent_hold_display.material.set_shader_parameter("progress", value)
