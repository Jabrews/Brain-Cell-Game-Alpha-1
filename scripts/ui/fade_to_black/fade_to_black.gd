extends Control

# components
@onready var round_label : Label = $RoundLabel
@onready var bg : ColorRect = $BG

var opacity_tween : Tween


func _ready() -> void:
	GLGameManagerBus.connect("proceed_next_round", _handle_next_round)
	
	modulate.a = 0.0
	visible = false


func _handle_next_round() -> void:
	
	print_stack()
	
	if opacity_tween:
		opacity_tween.kill()
	
	round_label.text = "Round " + str(GLGameManagerBus.current_round)
	
	visible = true
	round_label.visible = true
	bg.visible = true
	
	modulate.a = 0.0
	
	opacity_tween = create_tween()

	opacity_tween.tween_property(self, "modulate:a", 1.0, 2.0)

	opacity_tween.tween_callback(func():
		GLGameManagerBus.emit_signal("reset_player_position")
	)

	opacity_tween.tween_interval(2.0)

	opacity_tween.tween_property(self, "modulate:a", 0.0, 1.0)
	
	
	await opacity_tween.finished
	
	visible = false
