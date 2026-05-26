extends Label

var breathing_tween : Tween


func _ready() -> void:
	GLPlayerState.connect(
		"toggle_player_picked_up_axe_mount",
		_handle_toggle_player_picked_up_axe_mount
	)


func _handle_toggle_player_picked_up_axe_mount(toggle_value : bool) :

	if toggle_value:

		visible = true

		start_breathing()

	else:

		stop_breathing()

		visible = false


func start_breathing():

	# prevent duplicate tweens
	if breathing_tween:
		breathing_tween.kill()

	modulate.a = 1.0

	breathing_tween = create_tween()

	breathing_tween.set_loops()

	breathing_tween.tween_property(
		self,
		"modulate:a",
		0.35,
		1.2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	breathing_tween.tween_property(
		self,
		"modulate:a",
		1.0,
		1.2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func stop_breathing():

	if breathing_tween:
		breathing_tween.kill()

	modulate.a = 1.0
