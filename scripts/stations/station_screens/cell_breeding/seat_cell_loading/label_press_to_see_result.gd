extends Label

@export var move_distance : float = 10.0
@export var move_duration : float = 1.0

var start_position : Vector2

func _ready() -> void:
	start_position = position
	_start_bounce()

func _start_bounce() -> void:
	while true:
		var tween = create_tween()

		tween.tween_property(
			self,
			"position:y",
			start_position.y - move_distance,
			move_duration
		)

		tween.tween_property(
			self,
			"position:y",
			start_position.y,
			move_duration
		)

		await tween.finished
