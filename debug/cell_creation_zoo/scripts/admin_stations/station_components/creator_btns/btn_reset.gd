extends InteractableBtn 

#components 
@export var custom_creator_parent : Node3D 

func _on_btn_interacted():
	custom_creator_parent._handle_reset_btn()
	
