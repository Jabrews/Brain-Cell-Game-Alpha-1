extends Control

@export var hover_offset: Vector2 = Vector2(0, -8)
@export var idle_bob_amount: float = 3.0
@export var idle_bob_speed: float = 3.0
@export var hover_tween_speed: float = 0.12

var start_position: Vector2
var is_hovered: bool = false
var hover_tween: Tween


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	
	start_position = position
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	visibility_changed.connect(_handle_visibility_changed)


func _process(_delta: float) -> void:
	if not visible:
		return
	
	# Backup hover check. Important if button appears under the mouse.
	var mouse_is_over: bool = get_global_rect().has_point(get_global_mouse_position())
	
	if mouse_is_over and not is_hovered:
		_on_mouse_entered()
	elif not mouse_is_over and is_hovered:
		_on_mouse_exited()
	
	if is_hovered:
		if Input.is_action_just_pressed("attack"):
			_handle_pressed()
		return
	
	var bob_y: float = sin(Time.get_ticks_msec() / 1000.0 * idle_bob_speed) * idle_bob_amount
	position = start_position + Vector2(0, bob_y)


func _on_mouse_entered() -> void:
	is_hovered = true
	
	if hover_tween:
		hover_tween.kill()
	
	hover_tween = create_tween()
	hover_tween.tween_property(
		self,
		"position",
		start_position + hover_offset,
		hover_tween_speed
	)


func _on_mouse_exited() -> void:
	is_hovered = false
	
	if hover_tween:
		hover_tween.kill()
	
	hover_tween = create_tween()
	hover_tween.tween_property(
		self,
		"position",
		start_position,
		hover_tween_speed
	)


func _handle_visibility_changed() -> void:
	if visible:
		start_position = position
		is_hovered = false
		
		if hover_tween:
			hover_tween.kill()
	else:
		is_hovered = false


func _handle_pressed() -> void:
	get_parent()._on_button_button_down()
