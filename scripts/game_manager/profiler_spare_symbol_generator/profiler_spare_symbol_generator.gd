extends Node


func _ready() -> void:
	GLPrisonerProfilerComponentsBus.connect(
		"request_new_profiler_spare_icons",
		_handle_request_new_profiler_spare_icons
	)


func _handle_request_new_profiler_spare_icons() -> void:
	var spare_icons: Array[SpareIconConstuctor] = []

	var stats := ["strength", "intelligence", "community"]
	stats.shuffle()

	var min_to_create: int = IVPrisonerProfiler.spare_symbol_minimum_created
	var max_to_create: int = IVPrisonerProfiler.spare_symbol_max_created
	var spare_symbols_available: Array = IVPrisonerProfiler.spare_symbols_avaible

	var amount_to_create: int = 0

	if max_to_create > 0:
		amount_to_create = min_to_create

		while amount_to_create < max_to_create:
			var ran_num := randi_range(0, 100)

			if ran_num >= 50:
				amount_to_create += 1
			else:
				break

	amount_to_create = clamp(amount_to_create, 0, stats.size())

	for i in stats.size():
		var stat: String = stats[i]

		if i < amount_to_create:
			var random_symbol_data: Dictionary = spare_symbols_available.pick_random()

			var symbol_type: String = random_symbol_data.keys()[0]
			var symbol_direction: String = random_symbol_data[symbol_type].pick_random()
			var start_and_stop: Array[float] = pick_stop_start(stat)

			spare_icons.append(
				SpareIconConstuctor.new(
					stat,
					symbol_type,
					symbol_direction,
					start_and_stop[0],
					start_and_stop[1]
				)
			)
		else:
			spare_icons.append(
				SpareIconConstuctor.new(
					stat,
					"none",
					"none",
					0.0,
					0.0
				)
			)

	GLPrisonerProfilerComponentsBus.emit_signal(
		"recieve_profiler_spare_icons",
		spare_icons
	)


func pick_stop_start(stat_type: String) -> Array[float]:
	var max_stat_value: float = IVCellCreator.max_stat_value
	var lock_percentages: Array[float] = IVPrisonerProfiler.stat_lock_percantages

	var percentage_index: int

	match stat_type:
		"strength":
			percentage_index = IVPrisonerProfiler.strength_stat_lock_percant_index
		"intelligence":
			percentage_index = IVPrisonerProfiler.intelligence_stat_lock_percant_index
		"community":
			percentage_index = IVPrisonerProfiler.community_stat_lock_percant_index
		_:
			push_error("Invalid stat type: " + stat_type)
			return [0.0, 0.0]

	var lock_max: float = max_stat_value * lock_percentages[percentage_index]
	lock_max = round(lock_max * 10.0) / 10.0

	var available_increments: Array[float] = []
	var increment: float = IVPrisonerProfiler.stat_increment_amount

	var curr_value: float = 1.0

	while curr_value <= lock_max:
		var rounded_value: float = round(curr_value * 10.0) / 10.0
		available_increments.append(rounded_value)

		curr_value += increment

	if available_increments.is_empty() or available_increments[-1] != lock_max:
		available_increments.append(lock_max)

	var increment_max: int = available_increments.size() - 1

	if increment_max <= 0:
		return [0.0, lock_max]

	if increment_max < 7:
		return [0.0, available_increments[increment_max]]

	var min_gap: int = IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min
	var max_gap: int = IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max

	if increment_max < min_gap:
		return [available_increments[0], available_increments[increment_max]]

	var gap: int = randi_range(min_gap, max_gap)
	gap = min(gap, increment_max)

	var start_index: int = randi_range(0, increment_max - gap)
	var stop_index: int = start_index + gap

	var start: float = available_increments[start_index]
	var stop: float = available_increments[stop_index]

	return [start, stop]
