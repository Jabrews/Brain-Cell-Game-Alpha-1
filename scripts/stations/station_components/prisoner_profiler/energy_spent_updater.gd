extends Node

# components
@onready var energy_panel : Node3D = $"../EnergyPanel"

var energy_spent := {
	"strength": 0,
	"intelligence": 0,
	"community": 0,
}

var stat_cap_status := {
	"strength": "none",
	"intelligence": "none",
	"community": "none",
}

var prisoner_quantity_energy_spent : int = 10 # default cost for quantity 2


func _handle_reset_prisoners_created() -> void:
	for stat in energy_spent:
		energy_spent[stat] = 0
		stat_cap_status[stat] = "none"

	prisoner_quantity_energy_spent = 10


func _handle_clean_stat_value_change(stat_type : String, new_value : float) -> void:
	energy_spent[stat_type] = int(new_value * 0.05)
	get_total_energy_spent()

func _handle_toggle_clean_stat_disabled(stat_type : String, toggle_value : bool, original_value : float, orginal_stat_cap : String) -> void:
	if toggle_value == true:
		energy_spent[stat_type] = 0
		stat_cap_status[stat_type] = "none"

	if toggle_value == false:
		energy_spent[stat_type] = int(original_value * 0.05)
		stat_cap_status[stat_type] = orginal_stat_cap

	get_total_energy_spent()


func _handle_alert_symbol(stat_type : String, alert_type : String) -> void:
	stat_cap_status[stat_type] = alert_type
	get_total_energy_spent()


func _handle_prisoner_quanity(quantity : int) -> void:

	match quantity:
		2:
			prisoner_quantity_energy_spent = 10
		4:
			prisoner_quantity_energy_spent = 20
		_:
			prisoner_quantity_energy_spent = 0

	get_total_energy_spent()


func get_total_energy_spent() -> int:
	var total := prisoner_quantity_energy_spent
	
	for stat in energy_spent:
		total += energy_spent[stat]

		match stat_cap_status[stat]:
			"caution":
				total += 20
			"warning":
				total += 40

	energy_panel.handle_energy_to_spend_change(total)
	
	return total
