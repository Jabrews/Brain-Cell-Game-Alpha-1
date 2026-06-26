extends Node

# these carry into assembler
# other than energy
var strength_spare_icon : String = 'none'
var intelligence_spare_icon : String = 'none'
var community_spare_icon : String = 'none'

@onready var handle_energy : Node = $"../../../HandleEnergy"



func _activate(toggle_value : bool, selected_icon : Dictionary) -> void:
	match selected_icon['stat']:	
		'strength':
			if not toggle_value:			
				strength_spare_icon = 'none'			
			else: 
				strength_spare_icon = selected_icon['type']

		'intelligence':
			if not toggle_value:			
				intelligence_spare_icon = 'none'			
			else: 
				intelligence_spare_icon = selected_icon['type']

		'community':
			if not toggle_value:			
				community_spare_icon = 'none'			
			else: 
				community_spare_icon = selected_icon['type']
	
	handle_energy_spare_symbol_activated(toggle_value, selected_icon)
				
				
				
				
func handle_energy_spare_symbol_activated(toggle_value: bool, selected_icon: Dictionary) -> void:
	var stat_type: String = selected_icon['stat']

	# If the spare symbol is being turned off, remove its energy effect.
	if not toggle_value:
		handle_energy._update_spare_symbol_energy_used(stat_type, 0)
		return
	
	# If it is not an energy symbol, it should not affect energy.
	if selected_icon['type'] != 'energy':
		handle_energy._update_spare_symbol_energy_used(stat_type, 0)
		return
	
	if selected_icon['direction'] == 'down':
		handle_energy._update_spare_symbol_energy_used(stat_type, -20)
	elif selected_icon['direction'] == 'up':
		handle_energy._update_spare_symbol_energy_used(stat_type, 20)
	
	
	
	
	
	
