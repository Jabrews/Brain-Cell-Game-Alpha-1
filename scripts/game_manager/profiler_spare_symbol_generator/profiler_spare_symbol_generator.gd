extends Node


func _ready() -> void:
	GLPrisonerProfilerComponentsBus.connect("request_new_profiler_spare_icons", _handle_request_new_profiler_spare_icons )



func _handle_request_new_profiler_spare_icons() -> void:
	var spare_icons := {
		"strength": {
			"type": "none",
			"direction": "none",
			'start' : 0,
			'stop' : 0,
		},
		"intelligence": {
			"type": "none",
			"direction": "none",
			'start' : 0,
			'stop' : 0,
		},
		"community": {
			"type": "none",
			"direction": "none",
			'start' : 0,
			'stop' : 0,
		},
	}

	var min_to_create: int = IVPrisonerProfiler.spare_symbol_minimum_created
	var max_to_create: int = IVPrisonerProfiler.spare_symbol_max_created
	var spare_symbols_available: Array = IVPrisonerProfiler.spare_symbols_avaible

	if max_to_create <= 0:
		GLPrisonerProfilerComponentsBus.emit_signal(
			"recieve_profiler_spare_icons",
			spare_icons
		)
		return

	var stats := ["strength", "intelligence", "community"]
	stats.shuffle()

	var amount_to_create: int = min_to_create

	while amount_to_create < max_to_create:
		var ran_num := randi_range(0, 100)

		if ran_num >= 50:
			amount_to_create += 1
		else:
			break

	amount_to_create = clamp(amount_to_create, 0, stats.size())

	for i in amount_to_create:
		var stat: String = stats[i]

		var random_symbol_data: Dictionary = spare_symbols_available.pick_random()

		var symbol_type: String = random_symbol_data.keys()[0]
		var symbol_direction: String = random_symbol_data[symbol_type].pick_random()
		var start_and_stop : Array[float] = pick_stop_start(stats[i])

		spare_icons[stat] = {
			'stat' : stat,
			"type": symbol_type,
			"direction": symbol_direction,
			'start' : start_and_stop[0],
			'stop' : start_and_stop[1],
		}

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

	# Start at 1.0 instead of 0.0
	var curr_value: float = 1.0

	while curr_value <= lock_max:
		var rounded_value: float = round(curr_value * 10.0) / 10.0
		available_increments.append(rounded_value)

		curr_value += increment

	# Make sure lock_max is included
	if available_increments.is_empty() or available_increments[-1] != lock_max:
			available_increments.append(lock_max)


	# get a random range for our stop and start
	var start: float
	var stop: float

	var increment_max: int = available_increments.size() - 1
	
	# if not enough increments, use the entire area
	if increment_max < 7:
		start = 0.0
		stop = available_increments[increment_max]
		return [start, stop]


	# Pick start and stop indexes.
	
	# How many increment steps wide the range should be.
	var min_gap: int = IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_min
	var max_gap: int = IVPrisonerProfiler.spare_symbol_inbewteen_gap_range_max

	# If there are not enough increments, use the whole area.
	if increment_max < min_gap:
		start = available_increments[0]
		stop = available_increments[increment_max]
		return [start, stop]

	# Pick a random gap size: either 4 or 5 increments wide.
	var gap: int = randi_range(min_gap, max_gap)

	# If gap is too big for the current array, clamp it.
	gap = min(gap, increment_max)

	# Start must leave enough room for the gap.
	var start_index: int = randi_range(0, increment_max - gap)

	# Stop is 4-5 increments after start.
	var stop_index: int = start_index + gap

	start = available_increments[start_index] 
	stop = available_increments[stop_index]

	return [start, stop]
	
	
	
	
	

		
	
		
	
	
