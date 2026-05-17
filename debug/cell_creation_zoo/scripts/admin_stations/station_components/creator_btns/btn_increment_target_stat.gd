extends InteractableBtn 

#components 
@export var custom_creator_parent : Node3D

@export var increment_type : String 

func _on_btn_interacted():
	custom_creator_parent._handle_increment_target_stat_btn(increment_type)
