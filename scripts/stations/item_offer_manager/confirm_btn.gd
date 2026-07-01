extends InteractableBtn

# called on ready
func _connect_signals():
	GLHoldingDisplayBus.connect('end_hold', _handle_end_hold)


func _on_btn_interacted():
	if get_parent().waiting_for_confirm_btn:
		GLHoldingDisplayBus.emit_signal('start_hold', 3, 1, str(get_instance_id()))
	else : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')

func _handle_end_hold(hold_id : String, is_success : bool) :
	if hold_id == str(get_instance_id()) :
		if is_success :
			get_parent()._handle_confirm_btn_pressed()
