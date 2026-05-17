extends InteractableBtn 

#components 
@export var custom_creator_parent : Node3D

@export var direction : String 

func _on_btn_interacted():
	custom_creator_parent._handle_change_active_stat_indicator_direction_btn(direction)
