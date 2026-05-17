extends Node


func _handle_panel_cell_recieved(loaded_cell) :
	
	# delete if loaded cell
	if loaded_cell :
		GLCellManagerBus.emit_signal('delete_selected_collected_cell', loaded_cell)
		
