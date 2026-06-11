extends Node


func use(selected_stat : String, selected_cell : BrainCell, useable_item_obj : UseableItemObject) :
	
	GLPlayerLocalSoundsBus.emit_signal('scissors_used')
	
	GLUsableItemBus.emit_signal(
		'use_scissors',
		selected_cell,
		useable_item_obj,
		selected_stat,
	)

	GLUsableItemBus.emit_signal(
		'useable_item_used',
		true,
		useable_item_obj
	)
