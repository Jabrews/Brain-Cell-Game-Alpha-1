extends StaticBody3D
class_name InteractableBtn

func _ready() -> void:
	set_collision_layer_value(6, true)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	add_to_group('interactable')
	
	_connect_signals()
	_overide_ready()


func handle_btn_interacted():
	_on_btn_interacted()

# over-ride this method on the buttons script
func _on_btn_interacted():
	pass

# over-ride this method whenever adding signals
func _connect_signals() : 
	pass
	
func _overide_ready() :
	pass
	
