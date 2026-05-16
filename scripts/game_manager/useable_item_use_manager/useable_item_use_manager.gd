extends Node



func _ready() -> void:
	connect_signals()
	create_class_refrences()

#### INIT FUNCS #####
func connect_signals() : 
	GLUsableItemBus.connect('use_defect_shot', _handle_use_defect_shot)
	GLUsableItemBus.connect('use_hidden_shot', _handle_use_hidden_shot)

func create_class_refrences() : 
	pass
#####################


func _handle_use_defect_shot(selected_brain_cell : BrainCell, _useable_item_obj : UseableItemObject) : 
	selected_brain_cell.strength_defect -= 5
	GLCellManagerBus.emit_signal('cell_changed', selected_brain_cell)
	
func _handle_use_hidden_shot(selected_brain_cell : BrainCell, _useable_item_obj : UseableItemObject) : 
	selected_brain_cell.strength_hidden = false
	GLCellManagerBus.emit_signal('cell_changed', selected_brain_cell)
	
