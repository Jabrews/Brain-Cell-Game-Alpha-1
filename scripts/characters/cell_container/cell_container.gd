extends CharacterBody3D 

var designated_brain_cell : BrainCell

# components
@onready var screen_basic_reciever: Node2D = $StatDisplay/StatMesh/SubViewport/BasicRecieverScreen
@onready var defect_color_manager : Node = $DefectColorManager
@onready var offer_turn_into_flesh_bug_delay : Timer = $OfferTurnIntoFleshBugDelay

# state machine
@onready var state_machine : Node = $StateMachine
@onready var picked_up_state : Node = $StateMachine/PickedUp # for ray cast
@onready var idle_state : Node = $StateMachine/Idle

var on_stat_interpreter : bool = false

# when they die from breeding prevent
var spawn_flesh_bug_on_death : bool = true


func _ready() -> void:
	
	# update name in tree
	name = "CellContainer" + designated_brain_cell.name
	
	await get_tree().process_frame
	
	# we start a timer to randomly turn into flesh bug
	# this is from a shareholder offer
	if designated_brain_cell.turn_into_flesh_bug:
		var turn_delay_time = randi_range(5, 20)
		offer_turn_into_flesh_bug_delay.wait_time = turn_delay_time
		offer_turn_into_flesh_bug_delay.start()
		
	screen_basic_reciever._handle_brain_cell_recieved(designated_brain_cell)
	
	# des. cell changing listeners
	GLCellManagerBus.connect("cell_deleted", _handle_cell_deleted)
	GLCellManagerBus.connect("cell_changed", _handle_cell_changed)
	
	# jolt cell container event (defect manager)
	GLDefectEventMangerBus.connect("event_cell_container_jolt", _handle_cell_container_jolt)
	
	# update color and opacity
	defect_color_manager.update_defect_color_manager(designated_brain_cell)
	
	check_for_cell_dead_on_start()


# STATE MACHINE SWITCH HELPER 
func switch_cell_state(
	new_state : String,
	picked_up_ray_cast : RayCast3D = null
) :
	
	picked_up_state.player_ray_cast = picked_up_ray_cast
	
	match new_state:
		
		"idle":
			state_machine.switch_state(state_machine.State.IDLE)
		
		"picked_up":
			state_machine.switch_state(state_machine.State.PICKED_UP)
		
		"dying":
			state_machine.switch_state(state_machine.State.DYING)
		'froze' :
			state_machine.switch_state(state_machine.State.FROZE)
		'jolt' :
			state_machine.switch_state(state_machine.State.JOLT)
		
		_:
			push_error("invalid state: " + new_state)


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		
		# PREVENT gravity during picked up state
		if state_machine.get_current_state_name() == "picked_up":
			return
		
		velocity += get_gravity() * delta
		
	move_and_slide()


func _handle_cell_deleted(cell_name : String) :
	
	if cell_name != designated_brain_cell.name:
		return
		
	state_machine.switch_state(state_machine.State.DYING)


func _handle_cell_changed(changed_brain_cell : BrainCell) :
	
	if changed_brain_cell.name != designated_brain_cell.name:
		return
	

	
	designated_brain_cell = changed_brain_cell
	
	# check if cell is froze, if so change stat to frozen
	if designated_brain_cell.cell_is_frozen :
		if state_machine.curr_state.name != 'Froze' :		
			switch_cell_state('froze')
	# check if cell is frozen when it shouldnt be
	if not designated_brain_cell.cell_is_frozen :
		if state_machine.curr_state.name == 'Froze' :		
			switch_cell_state('idle')
		
	screen_basic_reciever._handle_brain_cell_recieved(designated_brain_cell)
	defect_color_manager.update_defect_color_manager(designated_brain_cell)
	
	check_for_cell_dead_on_update()
	



func _handle_cell_container_jolt(cell_name : String) :
	
	if cell_name != designated_brain_cell.name:
		return
	
	# prevent indv. cell jolt from occuring
	# we only want interpreter jolt to occur
	# (which then reaches cell)
	if on_stat_interpreter : 
		return
	
		
	state_machine.switch_state(state_machine.State.JOLT)


func has_fatal_defect() -> bool:
	
	return (
		designated_brain_cell.strength.defect>= IVCellCreator.max_stat_value
		or designated_brain_cell.intelligence.defect>= IVCellCreator.max_stat_value
		or designated_brain_cell.community.defect>= IVCellCreator.max_stat_value
	)


func kill_cell() -> void:
	
	await get_tree().create_timer(1.0).timeout
	
	GLCellManagerBus.emit_signal(
		"delete_selected_collected_cell",
		designated_brain_cell
	)
	
	state_machine.switch_state(state_machine.State.DYING)


func check_for_cell_dead_on_start() :
	
	#### defect death event ####
	if has_fatal_defect():
		
		# if they can die then kill em
		if IVCellBreeding.newly_breeded_cell_can_die_from_defect:
			
			await kill_cell()
		
		# if not. that was players free chance.
		# now next badly breeded cell will die
		else:
			
			IVCellBreeding.newly_breeded_cell_can_die_from_defect = true
			
			return
	#############################


func check_for_cell_dead_on_update() :
	
	#### age death event ####
	if designated_brain_cell.life_span <= 0:
		
		spawn_flesh_bug_on_death = false
		
		await kill_cell()
		
		return
	##########################
	
	
	#### defect death event ####
	if has_fatal_defect():
		
		await kill_cell()
		
		return
	############################


# when on hidden stat intepreter 
# this is a helper to prevent indiv. cell container jolt
# NOTE : the hidden intepreters itself can still jolt and decrease cell
func _toggle_cell_put_onto_hidden_interpreter(toggle_value) :
	on_stat_interpreter = toggle_value

func _on_offer_turn_into_flesh_bug_delay_timeout() -> void:
	
	GLCellManagerBus.emit_signal(
		"delete_selected_collected_cell",
		designated_brain_cell
	)
	
	state_machine.switch_state(state_machine.State.DYING)
	
	
	
