extends Area3D 

# componnets
@export var cell_reciever : Node 

@export var is_hidden_interpreter_panel : bool = false

var loaded_body : CharacterBody3D

@export var disable_spawn_flesh_bug_on_cell_death : bool = false
	
func _ready() -> void:
	
	monitoring = false
	
	connect('body_entered', _handle_body_entered)
	connect('body_exited', _handle_body_exited)
	
	GLCellManagerBus.connect("cell_changed", _handle_cell_changed)
	GLCellManagerBus.connect('cell_deleted', _handle_cell_deleted)
	
	await get_tree().physics_frame
	
	monitoring = true

	
func _handle_body_entered(body) : 
	if body.is_in_group('brain_cell_container') and not loaded_body:
		loaded_body = body		
		cell_reciever._handle_panel_body_recieved(loaded_body)
		if disable_spawn_flesh_bug_on_cell_death :
			body.spawn_flesh_bug_on_death  = false	
		if is_hidden_interpreter_panel : 
			body._toggle_cell_put_onto_hidden_interpreter(true)
		
		GLPlayerLocalSoundsBus.emit_signal('sound_panel_cell_loaded')


func _handle_body_exited(body) :
	if body.is_in_group('brain_cell_container'): 
		if body == loaded_body: 
			loaded_body = null
			if disable_spawn_flesh_bug_on_cell_death :
				body.spawn_flesh_bug_on_death  = true
			if is_hidden_interpreter_panel : 
				body._toggle_cell_put_onto_hidden_interpreter(false)
				
			cell_reciever._handle_panel_body_recieved(loaded_body)


# handling cell changed
func _handle_cell_changed(cell : BrainCell) : 
	if loaded_body : 
		if loaded_body.designated_brain_cell.name == cell.name :
			loaded_body.designated_brain_cell = cell
			cell_reciever._handle_panel_body_recieved(loaded_body)


# handling cell deleted
func _handle_cell_deleted(cell_name : String) : 
	if loaded_body : 
		if loaded_body.designated_brain_cell.name == cell_name :
			loaded_body = null 
			cell_reciever._handle_panel_body_recieved(loaded_body)
