extends InteractableBtn 

#components 
@onready var station_target_cell_creator : Node3D = $"../.."

func _on_btn_interacted():
	station_target_cell_creator._handle_lock_in_target_cell()
	
