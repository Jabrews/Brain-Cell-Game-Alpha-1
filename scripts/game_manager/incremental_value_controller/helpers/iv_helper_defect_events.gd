extends Node

@warning_ignore("shadowed_global_identifier")
func _update_defect_event_values(round : int, energy : int) -> void:

	var danger_level := get_energy_danger_level(energy)

	match round:
		1:
			IVDefectEventManager.stats_to_hide = []
		2:
			IVDefectEventManager.stats_to_hide = ["strength"]
		3:
			IVDefectEventManager.stats_to_hide = ["strength", "intelligence"]
		4:
			IVDefectEventManager.stats_to_hide = ["strength", "intelligence", "community"]

	apply_defect_values(round, danger_level)


func get_energy_danger_level(energy : int) -> int:
	# high energy = safer
	# low energy = more dangerous

	if energy > 75:
		return 0
	elif energy > 50:
		return 1
	elif energy > 25:
		return 2
	else:
		return 3


@warning_ignore("shadowed_global_identifier")
func apply_defect_values(round : int, danger_level : int) -> void:

	# default safe values
	IVDefectEventManager.no_event_chance = 98
	IVDefectEventManager.jolt_cell_container_chance = 1
	IVDefectEventManager.jolt_hidden_stat_interpreter_chance = 1
	IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt = 1
	IVDefectEventManager.interpreter_jolt_defect_increase = 20
	IVDefectEventManager.cell_container_jolt_defect_increase = 20

	match round:
		1:
			match danger_level:
				0:
					set_defect_values(98, 1, 1, 1, 20, 20)
				1:
					set_defect_values(90, 9, 1, 1, 20, 20)
				2:
					set_defect_values(80, 19, 1, 1, 20, 20)
				3:
					set_defect_values(70, 29, 1, 1, 20, 20)

		2:
			match danger_level:
				0:
					set_defect_values(98, 1, 1, 1, 20, 20)
				1:
					set_defect_values(80, 19, 1, 1, 20, 20)
				2:
					set_defect_values(70, 12, 18, 10, 25, 25)
				3:
					set_defect_values(50, 20, 30, 15, 30, 30)

		3:
			match danger_level:
				0:
					set_defect_values(98, 1, 1, 1, 20, 20)
				1:
					set_defect_values(75, 10, 15, 15, 20, 20)
				2:
					set_defect_values(70, 15, 15, 20, 25, 25)
				3:
					set_defect_values(65, 15, 20, 25, 30, 30)

		4:
			match danger_level:
				0:
					set_defect_values(98, 1, 1, 0, 10, 10)
				1:
					set_defect_values(80, 1, 19, 1, 15, 15)
				2:
					set_defect_values(60, 20, 20, 30, 30, 35)
				3:
					set_defect_values(50, 30, 20, 35, 35, 35)


func set_defect_values(
	no_event : int,
	container_jolt : int,
	interpreter_jolt : int,
	multiple_interpreter_chance : int,
	interpreter_increase : int,
	container_increase : int
) -> void:

	IVDefectEventManager.no_event_chance = no_event
	IVDefectEventManager.jolt_cell_container_chance = container_jolt
	IVDefectEventManager.jolt_hidden_stat_interpreter_chance = interpreter_jolt
	IVDefectEventManager.chance_for_multiple_hidden_stat_interpreter_jolt = multiple_interpreter_chance
	IVDefectEventManager.interpreter_jolt_defect_increase = interpreter_increase
	IVDefectEventManager.cell_container_jolt_defect_increase = container_increase
