extends Area3D 

# componnets
@export var cell_reciever :Node 
@export var breeding_panel_side : String 

var loaded_cell : BrainCell 

func _ready() -> void:
	connect('body_entered', _handle_body_entered)
	connect('body_exited', _handle_body_exited)
	
	# signals for updating cell receivers state
	GLCellManagerBus.connect("cell_changed", _handle_cell_changed)
	GLCellManagerBus.connect('cell_deleted', _handle_cell_deleted)
	

func _handle_body_entered(body) : 
	if body.is_in_group('brain_cell_container') and not loaded_cell :
		loaded_cell = body.designated_brain_cell		
		body.spawn_flesh_bug_on_death  = false
		cell_reciever._handle_breeding_panel_cell_recieved(loaded_cell, breeding_panel_side)

func _handle_body_exited(body) :
	if body.is_in_group('brain_cell_container') : 
		if body.designated_brain_cell == loaded_cell :
			loaded_cell = null
			body.spawn_flesh_bug_on_death  = true
			cell_reciever._handle_breeding_panel_cell_recieved(loaded_cell, breeding_panel_side)


# handling cell deleted
func _handle_cell_changed(cell : BrainCell) : 
	if loaded_cell : 
		if loaded_cell.name == cell.name :
			loaded_cell = cell
			cell_reciever._handle_breeding_panel_cell_recieved(loaded_cell, breeding_panel_side)

# handling cell changed
func _handle_cell_deleted(cell_name : String) : 
	if loaded_cell : 
		if loaded_cell.name == cell_name :
			loaded_cell = null 
			cell_reciever._handle_breeding_panel_cell_recieved(loaded_cell, breeding_panel_side)
