extends CharacterBody3D 

var designated_brain_cell : BrainCell 

# components
@onready var screen_basic_reciever: Node2D = $StatDisplay/StatMesh/SubViewport/BasicRecieverScreen

func _ready() -> void:
	
	await get_tree().process_frame
	
	screen_basic_reciever._handle_brain_cell_recieved(designated_brain_cell)
	
	# des. cell listenrs
	GLCellManagerBus.connect('cell_deleted', _handle_cell_deleted)
	GLCellManagerBus.connect('cell_changed', _handle_cell_changed)


func _process(delta: float) -> void:
	if not is_on_floor() :	
		velocity += get_gravity() * delta
	
	move_and_slide()
	
# called from interactable mesh
func handle_cell_interacted() :
	GLCellManagerBus.emit_signal('prisoner_picked_by_player', designated_brain_cell)
	self.queue_free()
	
func _handle_cell_deleted(cell_name : String) : 
	if cell_name == designated_brain_cell.name :
		self.queue_free()

func _handle_cell_changed(changed_brain_cell : BrainCell) : 
	if changed_brain_cell.name == designated_brain_cell.name : 
		designated_brain_cell = changed_brain_cell
		screen_basic_reciever._handle_brain_cell_recieved(designated_brain_cell)

	
	
