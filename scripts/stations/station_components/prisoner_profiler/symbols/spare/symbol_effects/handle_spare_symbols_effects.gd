extends Node

# these carry into assembler
# other than energy
var strength_spare_symbol : StatSpareSymbol = StatSpareSymbol.new('none', '')
var intelligence_spare_symbol : StatSpareSymbol = StatSpareSymbol.new('none', '')
var community_spare_symbol : StatSpareSymbol = StatSpareSymbol.new('none', '')

@onready var handle_energy : Node = $"../../../HandleEnergy"


func _activate(toggle_value : bool, spare_icon_constructor: SpareIconConstuctor) -> void:
	
	match spare_icon_constructor.stat :
		'strength':
			if not toggle_value:			
				strength_spare_symbol = StatSpareSymbol.new('none', '')
			else: 
				strength_spare_symbol = StatSpareSymbol.new(spare_icon_constructor.type, spare_icon_constructor.direction)

		'intelligence':
			if not toggle_value:			
				intelligence_spare_symbol= StatSpareSymbol.new('none', '')
			else: 
				intelligence_spare_symbol = StatSpareSymbol.new(spare_icon_constructor.type, spare_icon_constructor.direction)

		'community':
			if not toggle_value:			
				community_spare_symbol= StatSpareSymbol.new('none', '')
			else: 
				community_spare_symbol= StatSpareSymbol.new(spare_icon_constructor.type, spare_icon_constructor.direction)
	
	handle_energy_spare_symbol_activated(toggle_value, spare_icon_constructor)
				
				
func handle_energy_spare_symbol_activated(toggle_value: bool, spare_icon_constructor : SpareIconConstuctor) -> void:
	
	var stat_type: String = spare_icon_constructor.stat

	# If the spare symbol is being turned off, remove its energy effect.
	if not toggle_value:
		handle_energy._update_spare_symbol_energy_used(stat_type, 0)
		return
	
	# If it is not an energy symbol, it should not affect energy.
	if spare_icon_constructor.type != 'energy':
		handle_energy._update_spare_symbol_energy_used(stat_type, 0)
		return
	
	if spare_icon_constructor.direction == 'down':
		handle_energy._update_spare_symbol_energy_used(stat_type, -20)
	elif spare_icon_constructor.direction == 'up':
		handle_energy._update_spare_symbol_energy_used(stat_type, 20)
	
	
	
	
	
	
