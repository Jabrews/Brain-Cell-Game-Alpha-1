extends RayCast3D 

# componnets
@onready var ray_cast_controller_parent : Node3D = $".."

func _process(_delta):

	if not Input.is_action_just_pressed('interact'):
		return
	
	var collider = get_collider()
		
	if not  collider :	
		return
	
	if not collider.is_in_group('axe_mount'):
		return
	else :
		collider.on_axe_interacted()
