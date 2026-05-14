extends Node

# componnets
@export var cell_container_parent_node : Node


func _handle_jolt() :
	
	# get container charcter bodies
	var container_cells = cell_container_parent_node.get_children()
	
	# leave if no cell container	
	if len(container_cells) == 0 :
		return
	
	
	# pick random container	
	var random_container_cell = container_cells.pick_random()
	
	# emit signal
	GLDefectEventMangerBus.emit_signal('event_cell_container_jolt', random_container_cell.designated_brain_cell.name)
	
	
	
		
	
	
	
	
	
	
	
	
