extends StaticBody3D 

func on_axe_interacted():
	
	# drop axe if holding it
	if GLPlayerState.player_holding_axe_mount :
		GLPlayerState.emit_signal('toggle_player_picked_up_axe_mount', false)
		GLPlayerState.player_holding_axe_mount = false 
	
	# else pick it up
	else :
		GLPlayerState.emit_signal('toggle_player_picked_up_axe_mount', true)
		GLPlayerState.player_holding_axe_mount = true
	
	
