extends CharacterBody3D 

var designated_brain_cell : BrainCell

# components
@onready var screen_stat_displays: Node2D = $StatDisplay/StatMesh/SubViewport/StatDisplay
@onready var defect_color_manager : Node = $DefectColorManager

# state machine
@onready var state_machine : Node = $StateMachine
@onready var picked_up_state : Node = $StateMachine/PickedUp # for ray cast


func _ready() -> void:
	# update name in tree
	name = 'CellContainer' + designated_brain_cell.name
	
	await get_tree().process_frame
	
	screen_stat_displays.update_screen(designated_brain_cell)
	
	# des. cell changing listenrs
	GLCellManagerBus.connect('cell_deleted', _handle_cell_deleted)
	GLCellManagerBus.connect('cell_changed', _handle_cell_changed)
	
	# jolt cell container event (defect manager)
	GLDefectEventMangerBus.connect('event_cell_container_jolt', _handle_cell_container_jolt)
	
	# update color and opacity
	defect_color_manager.update_defect_color_manager(designated_brain_cell)
	
# STATE MACHINE SWITCH HELPER 
func switch_cell_state(new_state : String, picked_up_ray_cast : RayCast3D = null) :
	
	# reset picked up data
	picked_up_state.player_ray_cast= null
	
	match new_state:
		"idle":
			state_machine.switch_state(state_machine.State.IDLE)
		
		"picked_up":
			picked_up_state.player_ray_cast = picked_up_ray_cast 
			state_machine.switch_state(state_machine.State.PICKED_UP)
		"dying":
			state_machine.switch_state(state_machine.State.DYING)
		
		_:
			push_error("invalid state: " + new_state)
	
	

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		
		# PREVENT gravity during picked up state		
		if state_machine.get_current_state_name() == 'picked_uo' : 
			return
		
		velocity += get_gravity() * delta
		
	move_and_slide()
		
		
func _handle_cell_deleted(cell_name : String) : 
	if cell_name == designated_brain_cell.name :
		state_machine.switch_state(state_machine.State.DYING)		


func _handle_cell_changed(changed_brain_cell : BrainCell) : 
	if changed_brain_cell.name == designated_brain_cell.name : 
		designated_brain_cell = changed_brain_cell
		screen_stat_displays.update_screen(designated_brain_cell)
		defect_color_manager.update_defect_color_manager(designated_brain_cell)
	
	
func _handle_cell_container_jolt(cell_name : String) :
	if cell_name == designated_brain_cell.name :
		state_machine.switch_state(state_machine.State.JOLT)		
		
		

	
	
