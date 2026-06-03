extends Node

# componets
@export var cell_manager : Node
#@export var useable_item_manager : Node3D
#@export var observe_player_hand : Node



func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('debug1') :	
		pass
		
		##observe_player_hand.find_case()
		#
		##GLDefectEventMangerBus.emit_signal('event_hidden_stat_interpreter_jolt', ['strength'])
		#
		#print('DEBUG ACTIVATED - printing cell collection via refrences')
		#var collected_array_len = len(GLCellManagerBus.collected_cells_refrence)
		#print('array len : ', str(collected_array_len))		
		#
		#for cell in GLCellManagerBus.collected_cells_refrence: 
			#print('name : ', cell.name, ' strength : ', str(cell.strength), ' strength-def : ', str(cell.strength_defect))
			
		#print('DEBUG FINISHED')
		#print('stat offer 1 active : ', GLShareholderOfferState.offer_1_active)
		#print('stat offer 2 active : ', GLShareholderOfferState.offer_2_active)
		#print('stat offer 3 active : ', GLShareholderOfferState.offer_3_active)
		#print('stat offer 4 active : ', GLShareholderOfferState.offer_4_active)
		#print('stat offer 5 active : ', GLShareholderOfferState.offer_5_active)
		#print('stat offer 6 active : ', GLShareholderOfferState.offer_6_active)
		#print('stat offer 7 active : ', GLShareholderOfferState.offer_7_active)
		#print('stat offer 8 active : ', GLShareholderOfferState.offer_8_active)
		pass
		
	
	
	if Input.is_action_just_pressed('debug2') :	
		print('DEBUG ACTIVATED - printing cell collection via manager')
		var collected_array_len = len(cell_manager.collected_cells)
		print('array len : ', str(collected_array_len))		
		
		print('DEBUG FINISHED')
#
