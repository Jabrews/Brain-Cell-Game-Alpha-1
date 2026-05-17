extends Node

# componets
@export var cell_manager : Node
#@export var useable_item_manager : Node3D
@export var observe_player_hand : Node



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug1') :	
		
		observe_player_hand.find_case()
		
		#GLDefectEventMangerBus.emit_signal('event_hidden_stat_interpreter_jolt', ['strength'])
		
		#print('DEBUG ACTIVATED - printing cell collection via refrences')
		#var collected_array_len = len(GLCellManagerBus.collected_cells_refrence)
		#print('array len : ', str(collected_array_len))		
		#
		#for cell in GLCellManagerBus.collected_cells_refrence: 
			#print('name : ', cell.name, ' strength : ', str(cell.strength), ' strength-def : ', str(cell.strength_defect))
		#
		#print('DEBUG FINISHED')
	
	
	if Input.is_action_just_pressed('debug2') :	
		print('DEBUG ACTIVATED - printing cell collection via manager')
		var collected_array_len = len(cell_manager.collected_cells)
		print('array len : ', str(collected_array_len))		
		
		for cell : BrainCell in cell_manager.collected_cells: 
			print('name : ', cell.name, ' strength : ', str(cell.strength), ' strength-def : ', str(cell.strength_defect))
			print(cell.intelligence_defect)
		
		print('DEBUG FINISHED')
		
		
		
	
	
	
