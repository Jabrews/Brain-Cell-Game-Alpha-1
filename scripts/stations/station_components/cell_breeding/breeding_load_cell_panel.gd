extends Area3D

# components
@export var cell_reciever : Node
@export var breeding_panel_side : String

var loaded_cell : BrainCell

@export var disable_spawn_flesh_bug_on_cell_death : bool = false


func _ready() -> void:
	monitoring = false

	connect("body_entered", _handle_body_entered)
	connect("body_exited", _handle_body_exited)

	GLCellManagerBus.connect("cell_changed", _handle_cell_changed)
	GLCellManagerBus.connect("cell_deleted", _handle_cell_deleted)

	await get_tree().physics_frame

	monitoring = true


func _send_cell_to_receiver(cell : BrainCell) -> void:
	if cell_reciever.has_method("_handle_panel_cell_recieved"):
		cell_reciever._handle_panel_cell_recieved(cell)

	elif cell_reciever.has_method("_handle_brain_cell_recieved"):
		cell_reciever._handle_brain_cell_recieved(cell)

	elif cell_reciever.has_method("_handle_breeding_panel_cell_recieved"):
		cell_reciever._handle_breeding_panel_cell_recieved(cell, breeding_panel_side)

	else:
		push_error("cell receiver has invalid methods")


func _handle_body_entered(body) -> void:
	if body.is_in_group("brain_cell_container") and not loaded_cell:
		loaded_cell = body.designated_brain_cell

		_send_cell_to_receiver(loaded_cell)

		if disable_spawn_flesh_bug_on_cell_death:
			body.spawn_flesh_bug_on_death = false

		GLPlayerLocalSoundsBus.emit_signal("sound_panel_cell_loaded")


func _handle_body_exited(body) -> void:
	if body.is_in_group("brain_cell_container"):
		if body.designated_brain_cell == loaded_cell:
			loaded_cell = null

			if disable_spawn_flesh_bug_on_cell_death:
				body.spawn_flesh_bug_on_death = true

			_send_cell_to_receiver(null)


func _handle_cell_changed(cell : BrainCell) -> void:
	if loaded_cell and loaded_cell.name == cell.name:
		loaded_cell = cell
		_send_cell_to_receiver(loaded_cell)


func _handle_cell_deleted(cell_name : String) -> void:
	if loaded_cell and loaded_cell.name == cell_name:
		loaded_cell = null
		_send_cell_to_receiver(null)
