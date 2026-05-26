extends Sprite2D

func _ready() -> void:
	GLPlayerState.connect('player_health_changed', _handle_player_health_changed)
		
	
	
func _handle_player_health_changed() :

	print("player health : ", str(GLPlayerState.player_health))

	match GLPlayerState.player_health:
		0:
			get_tree().current_scene.queue_free()

		1:
			change_blood_overlay_opacity(1.0)

		2:
			
			change_blood_overlay_opacity(0.7)

		3:
			change_blood_overlay_opacity(0.3)
		
		4 : 
			change_blood_overlay_opacity(0.0)
		
func change_blood_overlay_opacity(opacity : float) :

	var tween = create_tween()

	tween.tween_property(
		self,
		"modulate:a",
		opacity,
		0.4
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
