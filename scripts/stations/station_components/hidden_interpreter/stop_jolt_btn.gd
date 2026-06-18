extends InteractableBtn


# called on ready
func _connect_signals():
	GLHoldingDisplayBus.connect('end_hold', _handle_end_hold)


func _on_btn_interacted():
	if get_parent().jolt_active :
		GLHoldingDisplayBus.emit_signal('start_hold', 3, 1, str(get_instance_id()))

func _handle_end_hold(hold_id : String, is_success : bool) :
	if hold_id == str(get_instance_id()) :
		if is_success :
			get_parent()._handle_stop_jolt_btn_pressed()
