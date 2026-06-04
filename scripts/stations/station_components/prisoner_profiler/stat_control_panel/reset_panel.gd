extends Node

@onready var parent_stat_control_panel : Node3D = $".."
@onready var energy_addition_label : Label3D = $"../RangeControl/CurrStatDisplayLabelsl/Addition/CleanStatAdditon"
@onready var clean_stat_range_label : Label3D = $"../RangeControl/CurrStatDisplayLabelsl/CleanRange/CleanStatRange"
@onready var cap_control_screen : Node2D = $"../RangeControl/CapControlTv/SubViewport/CapControll"
@onready var helper_addition_energy_value : Node = $"../HelperAdditionEnergyValue"

func _reset() :
	parent_stat_control_panel._handle_toggle_on_off(true)
	parent_stat_control_panel.current_stat_value = 0
	helper_addition_energy_value.current_value = 0
	energy_addition_label.text = '- 0'
	clean_stat_range_label.text = 'low'
	cap_control_screen._handle_reset()
