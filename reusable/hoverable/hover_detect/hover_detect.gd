extends RayCast3D 


var current_hovered : Node = null

func _process(_delta):

	var new_hovered : Node = null

	if is_colliding():
		var collider = get_collider()

		if not collider is Node:
			return

		var hoverable : Node = collider
		
		while hoverable and not hoverable.is_in_group("hoverable"):
			hoverable = hoverable.get_parent()

		if hoverable:
			new_hovered = hoverable

	# -----------------------------
	# if hover changed (INCLUDING to null)
	# -----------------------------
	if new_hovered != current_hovered:
		
		if GLHoldingDisplayBus.player_is_holding :
			GLHoldingDisplayBus.emit_signal('player_interupted_hold')
		

		# exited hover
		if current_hovered:
			current_hovered.exit_hover()

		# entered hover
		if new_hovered:
			new_hovered.display_hover()

		current_hovered = new_hovered
