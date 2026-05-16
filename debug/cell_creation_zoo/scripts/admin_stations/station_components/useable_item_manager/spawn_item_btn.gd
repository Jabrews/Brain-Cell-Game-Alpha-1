extends InteractableBtn 

@export var item_type: String

# componnets
@onready var spawn_item_pos : Node3D = $"../SpawnItemPos"

func _on_btn_interacted() : 
	
	var parent_manager : Node3D = get_parent()
	
	if item_type == 'defect' :
		parent_manager._spawn_item_btn_pressed(item_type)
	
	elif item_type == 'hidden' :
		parent_manager._spawn_item_btn_pressed(item_type)
	
	else :
		push_error('invalid item type for spawn item btn')
