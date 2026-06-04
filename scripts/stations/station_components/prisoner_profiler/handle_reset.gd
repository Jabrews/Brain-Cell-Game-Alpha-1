extends Node

@onready var parent_station_prisoner_profiler : Node3D = $".."
@onready var energy_panel : Node3D = $"../EnergyPanel"
@onready var stat_control_panels : Array[Node3D] = [
	$"../StatControllPanels/StatControlPanel",
	$"../StatControllPanels/StatControlPanel2",
	$"../StatControllPanels/StatControlPanel3"
]
@onready var energy_spent_updater : Node = $"../EnergySpentUpdater"
@onready var prisoner_quanity_btns : Node3D = $"../PrisonerQuanityBtns"


func _reset() :
	
	# station prisoner profiler 
	# all these gross vars can be reset
	parent_station_prisoner_profiler.clean_strength = 0.0
	parent_station_prisoner_profiler.clean_intelligence = 0.0
	parent_station_prisoner_profiler.clean_community = 0.0
	parent_station_prisoner_profiler.strength_caution_active = false
	parent_station_prisoner_profiler.strength_warning_active = false
	parent_station_prisoner_profiler.intelligence_caution_active =  false
	parent_station_prisoner_profiler.intelligence_warning_active = false
	parent_station_prisoner_profiler.community_caution_active = false
	parent_station_prisoner_profiler.community_warning_active = false
	parent_station_prisoner_profiler.prisoner_quantity = 2
	
	# prisoner quanity btn
	prisoner_quanity_btns._prisoner_quanity_btn_selected(2)
	
	
	# energy spent updater
	energy_spent_updater._handle_reset_prisoners_created()
	
	# energy panel
	energy_panel._handle_profiler_prisoners_generated()
	

	
	# stat control panels
	for control_panel : Node3D in stat_control_panels :
		control_panel._handle_toggle_on_off(true)
		control_panel.current_stat_value = 0
		control_panel.helper_addition_energy_value.current_value = 0
		control_panel.clean_stat_addition_label.text = '- 0'
		# screen cap control 
		control_panel.screen_cap_control._handle_reset()
	
	
