extends Node

# main vars
var target_cell : BrainCell
var prisoner_cells : Array[BrainCell] = []
var collected_cells : Array[BrainCell] = []



func _ready() -> void:
	GLCellManagerBus.connect('prisoner_picked_by_player', _handle_prisoner_picked_by_player)
	GLCellManagerBus.connect('delete_remaining_prisoners', _handle_delete_remaining_prisoners)
	GLCellManagerBus.connect('cell_breeded', _handle_cell_breeded)
	GLCellManagerBus.connect('delete_selected_collected_cell', _handle_delete_selected_collected_cell)
	GLCellManagerBus.connect('hidden_stat_interpreted', _handle_hidden_stat_interpreted)
	GLCellManagerBus.connect('interpreter_jolt_increase_cell_defect', _handle_interpreter_jolt_increase_cell_defect)
	GLCellManagerBus.connect('cell_container_jolt_increase_cell_defect', _handle_cell_container_jolt_increase_cell_defect)
	GLCellManagerBus.connect('delete_cells_for_next_round', _handle_delete_cells_for_next_round)
	
	## DEBUG
	#GLCellManagerBus.connect('debug_collected_cells_and_target_create', _handle_debug)
	
	## CREATION ZOO
	print('DEBUG : cell manager is connecting signals for cell creation zoo')
	GLCreationZooBus.connect('admin_create_target_cell', _handle_admin_create_target_cell)
	GLCreationZooBus.connect('admin_create_collected_cell', _handle_create_collected_cell)	

#### setters ####
func set_collected_cells(new_cells : Array[BrainCell]) -> void :
	
	collected_cells = new_cells 
	GLCellManagerBus.collected_cells_refrence = new_cells  
	GLCellManagerBus.emit_signal('cells_updated')

func set_prisoner_cells(new_cells : Array[BrainCell]) -> void :
	prisoner_cells = new_cells
	GLCellManagerBus.prisoner_cells_refrence = new_cells
	GLCellManagerBus.emit_signal('cells_updated')

func set_target_cell(new_cell : BrainCell) -> void :
	target_cell = new_cell
	GLCellManagerBus.target_cell_refrence = target_cell
	GLCellManagerBus.emit_signal('cells_updated')
	GLCellManagerBus.emit_signal('target_cell_created', target_cell )
	
#################

#### updaters ####
func update_collected_cells(cells_to_update: Array[BrainCell]) -> void:
	
	if len(cells_to_update) <= 0:
		push_error("cell_manager, col_update_cells : update cells array empty")
		return
	
	var new_collected_cells: Array[BrainCell] = []
	
	for cell in collected_cells:
		var updated_cell = cell
		
		for update_cell in cells_to_update:
			if cell.name == update_cell.name:
				updated_cell = update_cell
				GLCellManagerBus.emit_signal('cell_changed', update_cell)
				break
				
		var cell_dead = check_collected_cell_dead(updated_cell)
		if cell_dead : 

			GLCellManagerBus.emit_signal('cell_deleted',updated_cell.name)
		else : 
			new_collected_cells.append(updated_cell)
	
	set_collected_cells(new_collected_cells)


func update_prisoner_cells(cells_to_update: Array[BrainCell]) -> void:
	
	if len(cells_to_update) <= 0:
		push_error("cell_manager, pris_update_cells : update cells array empty")
		return
	
	var new_prisoner_cells: Array[BrainCell] = []
	
	for cell in prisoner_cells:
		var updated_cell = cell
		
		for update_cell in cells_to_update:
			if cell.name == update_cell.name:
				updated_cell = update_cell
				GLCellManagerBus.emit_signal('cell_changed', update_cell)
				break
		
		new_prisoner_cells.append(updated_cell)
	
	set_prisoner_cells(new_prisoner_cells)
##################
	
#### delete cells ####	

func delete_collected_cells(cells_to_delete : Array[BrainCell]) -> void :
	
	if len(cells_to_delete) <= 0:
		push_error("cell_manager, col_delete_cells : delete cells array empty")
		return
	
	var new_collected_cells : Array[BrainCell] = []
	
	for cell in collected_cells:
		var should_delete = false
		
		for delete_cell in cells_to_delete:
			if cell.name == delete_cell.name:
				should_delete = true
				GLCellManagerBus.emit_signal('cell_deleted', cell.name)
				break
		
		if not should_delete:
			new_collected_cells.append(cell)
	
	set_collected_cells(new_collected_cells)


func delete_prisoner_cells(cells_to_delete : Array[BrainCell]) -> void :
	
	if len(cells_to_delete) <= 0:
		push_error("cell_manager, pris_delete_cells : delete cells array empty")
		return
	
	var new_prisoner_cells : Array[BrainCell] = []
	
	for cell in prisoner_cells:
		var should_delete = false
		
		for delete_cell in cells_to_delete:
			if cell.name == delete_cell.name:
				should_delete = true
				GLCellManagerBus.emit_signal('cell_deleted', cell.name)
				break
		
		if not should_delete:
			new_prisoner_cells.append(cell)
	
	set_prisoner_cells(new_prisoner_cells)

######################

### CHECK IF CELL DEAD ####
func check_collected_cell_dead(collected_cell: BrainCell) -> bool:
	
	# check max defect
	if collected_cell.strength_defect >= IVCellCreator.max_stat_value:
		GLCellManagerBus.emit_signal('cell_deleted', collected_cell.name)
		return true
		
	elif collected_cell.intelligence_defect >= IVCellCreator.max_stat_value:
		GLCellManagerBus.emit_signal('cell_deleted', collected_cell.name)
		return true
		
	elif collected_cell.community_defect >= IVCellCreator.max_stat_value:
		GLCellManagerBus.emit_signal('cell_deleted', collected_cell.name)
		return true
	
	# check lifespan
	if collected_cell.life_span <= 0:
		GLCellManagerBus.emit_signal('cell_deleted', collected_cell.name)
		return true
	
	return false
##############################



#### CORE ####
func _handle_prisoner_picked_by_player(prisoner_cell : BrainCell):
	# delete from prisoners
	delete_prisoner_cells([prisoner_cell])
	
	# add to collection
	var new_collection = collected_cells
	new_collection.append(prisoner_cell)
	set_collected_cells(new_collection)
	
	# spawn container 
	GLCellManagerBus.emit_signal('cell_added_to_collection', prisoner_cell)
	
func _handle_delete_remaining_prisoners() :
	
	# delete each cell remaning	
	for cell in prisoner_cells :
		GLCellManagerBus.emit_signal('cell_deleted', cell.name)
	
	# set it empty. ran out of prisoner grab attempts
	set_prisoner_cells([])

	
func _handle_cell_breeded(old_cell_1 : BrainCell, old_cell_2 : BrainCell, new_cell : BrainCell):
	
	var new_cell_collection = collected_cells.duplicate()
	
	# delete old cells FIRST
	delete_collected_cells([old_cell_1, old_cell_2])
	
	# re-sync after delete
	new_cell_collection = collected_cells.duplicate()
	
	# add new cell
	new_cell_collection.append(new_cell)
	
	# set
	set_collected_cells(new_cell_collection)
	
	# update containers
	GLCellManagerBus.emit_signal('cell_deleted', old_cell_1.name)
	GLCellManagerBus.emit_signal('cell_deleted', old_cell_2.name)


func _handle_delete_selected_collected_cell(collected_cell : BrainCell) :
	delete_collected_cells([collected_cell])
	

func _handle_hidden_stat_interpreted(selected_cell : BrainCell, selected_stat : String) :
	
	
	match selected_stat :
		'strength' :
			selected_cell.strength_hidden = false
		'intelligence' :
			selected_cell.intelligence_hidden = false
		'community' :
			selected_cell.community_hidden = false
		
	update_collected_cells([selected_cell])
		
		
func _handle_interpreter_jolt_increase_cell_defect(selected_cell : BrainCell, selected_stat : String) :
			
	var jolt_defect_increase_amount = IVDefectEventManager.interpreter_jolt_defect_increase
	
	match selected_stat :
		'strength' :
			selected_cell.strength_defect += jolt_defect_increase_amount
		'intelligence' :
			selected_cell.intelligence_defect += jolt_defect_increase_amount
		'community' :
			selected_cell.community_defect += jolt_defect_increase_amount
	update_collected_cells([selected_cell])
	

func _handle_cell_container_jolt_increase_cell_defect(selected_cell : BrainCell) :
	
		var jolt_defect_increase_amount = IVDefectEventManager.cell_container_jolt_defect_increase
	
		selected_cell.strength_defect += jolt_defect_increase_amount 
		selected_cell.intelligence_defect += jolt_defect_increase_amount 
		selected_cell.community_defect += jolt_defect_increase_amount
	
		update_collected_cells([selected_cell])
	
func _handle_delete_cells_for_next_round() :
	
	for cell in collected_cells :	
		GLCellManagerBus.emit_signal('cell_deleted', cell.name)	
	
	for cell in prisoner_cells :
		GLCellManagerBus.emit_signal('cell_deleted', cell.name)	
	
	set_collected_cells([])
	set_prisoner_cells([])


### OTHER ZOOS ###

#func _handle_debug(new_collected_cells : Array[BrainCell], new_target_cell : BrainCell) : 
	#print('DEBUG : getting debug created cells')
	#set_target_cell(new_target_cell)
	#set_collected_cells(new_collected_cells)
###################


#### CREATION ZOO ####

func _handle_admin_create_target_cell(new_target_cell : BrainCell) :
	set_target_cell(new_target_cell)

func _handle_create_collected_cell(new_collected_cell : BrainCell) :
	# add to collection
	var new_collection = collected_cells
	
	new_collection.append(new_collected_cell)
	set_collected_cells(new_collection)
	
	# spawn container 
	GLCellManagerBus.emit_signal('cell_added_to_collection', new_collected_cell)
#####################
	
	
	
