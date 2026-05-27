extends Node



func _ready() -> void:
	connect_signals()

#### INIT FUNCS #####
func connect_signals() : 
	GLUsableItemBus.connect('use_defect_shot', _handle_use_defect_shot)
	GLUsableItemBus.connect('use_hidden_shot', _handle_use_hidden_shot)
	GLUsableItemBus.connect('use_steroid', _handle_use_steroid)


func _handle_use_defect_shot(selected_brain_cell : BrainCell, _useable_item_obj : UseableItemObject) : 
	selected_brain_cell.strength_defect -= IVItemStats.defect_shot_decrease
	selected_brain_cell.intelligence_defect -= IVItemStats.defect_shot_decrease
	selected_brain_cell.community_defect -= IVItemStats.defect_shot_decrease
	GLCellManagerBus.emit_signal('cell_changed', selected_brain_cell)
	
func _handle_use_hidden_shot(selected_brain_cell : BrainCell, _useable_item_obj : UseableItemObject) : 
	selected_brain_cell.strength_hidden = false
	selected_brain_cell.intelligence_hidden = false
	selected_brain_cell.community_hidden = false
	GLCellManagerBus.emit_signal('cell_changed', selected_brain_cell)
	

func _handle_use_steroid(selected_brain_cell : BrainCell, _useable_item_obj : UseableItemObject) :
	# increase clean and defect stats by 30% of max stat value
	var steroid_increase : float = IVCellCreator.max_stat_value * .30
	
	selected_brain_cell.strength += steroid_increase
	selected_brain_cell.intelligence += steroid_increase
	selected_brain_cell.community += steroid_increase
	
	selected_brain_cell.strength_defect += steroid_increase
	selected_brain_cell.intelligence_defect += steroid_increase
	selected_brain_cell.community_defect += steroid_increase
	
	GLCellManagerBus.emit_signal('cell_changed', selected_brain_cell)
