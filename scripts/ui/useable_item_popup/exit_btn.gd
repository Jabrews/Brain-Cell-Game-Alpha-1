extends TextureRect 

var original_scale : Vector2
var scale_tween : Tween
var mouse_hovered_over : bool = false

func _ready() -> void:
	original_scale = scale	
	
	mouse_entered.connect(_handle_mouse_entered)
	mouse_exited.connect(_handle_mouse_exited)

func _process(_delta: float) -> void: 
	if mouse_hovered_over :
		if Input.is_action_just_pressed('attack') :
			get_parent().hide_popup()

func _handle_mouse_entered() -> void:
	_tween_scale(original_scale * 1.1)
	mouse_hovered_over = true

func _handle_mouse_exited() -> void:
	_tween_scale(original_scale)
	mouse_hovered_over = false 

func _tween_scale(target_scale : Vector2) -> void:
	if scale_tween:
		scale_tween.kill()

	scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", target_scale, 0.12)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
