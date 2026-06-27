extends Node

var prisoner_quanity_btn_energy_used : int = 0
var stat_value_energy_used = {
	'strength' : 0,
	'intelligence' : 0,
	'community' : 0,
}
var spare_symbols_energy_used = {
	'strength' : 0,
	'intelligence' : 0,
	'community' : 0,
}

var current_energy : int = 0
var impending_energy : int = 0

# componnets
@onready var helper_update_energy_panel : Node = $UpdateEnergyPanel


func _ready() -> void:
	GLGameManagerBus.connect('process_next_round', _handle_next_round)
	GLGameManagerBus.connect('proceed_next_energy_turn', _handle_next_turn)
	GLGameManagerBus.connect('energy_changed', _handle_energy_changed)


func _handle_next_round() -> void:
	
	current_energy = GLGameManagerBus.curr_energy
	reset_energy_used()
	recalculate_impending_energy()


func _handle_next_turn() -> void:
	
	# breif await
	# kinda hacky but prevent _ready messup
	await get_tree().create_timer(0.1).timeout
	
	recalculate_impending_energy()
	
	GLGameManagerBus.curr_energy = impending_energy
	current_energy = impending_energy
	
	reset_energy_used()
	recalculate_impending_energy()


# happens when energy changes elsewhere
func _handle_energy_changed() -> void:
	current_energy = GLGameManagerBus.curr_energy
	recalculate_impending_energy()
	helper_update_energy_panel._update()


func reset_energy_used() -> void:
	
	
	prisoner_quanity_btn_energy_used = 0
	
	for key in stat_value_energy_used:
		stat_value_energy_used[key] = 0
	
	for key in spare_symbols_energy_used:
		spare_symbols_energy_used[key] = 0
	
	helper_update_energy_panel._update()


func recalculate_impending_energy() -> void:
	impending_energy = current_energy + get_total_energy_used()


func get_total_energy_used() -> int:
	var total : int = prisoner_quanity_btn_energy_used
	
	for key in stat_value_energy_used:
		total += stat_value_energy_used[key]
	
	for key in spare_symbols_energy_used :
		total += spare_symbols_energy_used[key]
	
	return total
	
	
func _update_energy_stat_value_used(stat_type : String, new_value : int) -> void:
	var value_increment : int = IVPrisonerProfiler.stat_increment_amount
	var energy_decrease_per_increment : int = IVPrisonerProfiler.per_stat_increment_energy_decrease
	
	@warning_ignore("integer_division")
	var energy_decrease : int = (new_value / value_increment) * energy_decrease_per_increment
	
	stat_value_energy_used[stat_type] = -energy_decrease
	
	recalculate_impending_energy()
	helper_update_energy_panel._update()
	
func _update_spare_symbol_energy_used(stat_type : String, new_value : int) -> void:
	
	spare_symbols_energy_used[stat_type] = new_value
	
	recalculate_impending_energy()
	helper_update_energy_panel._update()
	
	
func _update_energy_toggle_stat_value_enabled(stat_type : String, toggle_value : bool, last_value : int) -> void:
	# turned on
	if toggle_value == true:
		_update_energy_stat_value_used(stat_type, last_value)
		return
	
	# turned off
	if toggle_value == false:
		match stat_type:
			'strength':
				stat_value_energy_used['strength'] = 5
			'intelligence':
				stat_value_energy_used['intelligence'] = 5
			'community':
				stat_value_energy_used['community'] = 5
	
	recalculate_impending_energy()
	helper_update_energy_panel._update()


func _update_energy_player_pressed_prisoner_quanity_btn(prisoner_quanity : int) -> void:
	
	if prisoner_quanity == 2:
		prisoner_quanity_btn_energy_used = -10
	elif prisoner_quanity == 4:
		prisoner_quanity_btn_energy_used = -20
	else:
		prisoner_quanity_btn_energy_used = 0
	
	recalculate_impending_energy()
	helper_update_energy_panel._update()
	

func _check_if_energy_valid() -> bool :
	
	recalculate_impending_energy()
	
	if impending_energy	<= 0 :
		return false
	else :
		return true
	
	
