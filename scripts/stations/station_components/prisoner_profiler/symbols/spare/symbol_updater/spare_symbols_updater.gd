extends Node

@onready var defect_symbols: Node = $Defect
@onready var energy_symbols: Node = $Energy
@onready var good_mutation_symbols: Node = $GoodMutation
@onready var bad_mutation_symbols: Node = $BadMutation

@onready var handle_spare_symbols: Node = $".."


func _update_large_stat_screens(stat_selected_icons: Dictionary) -> void:
	reset_large_screens()
	
	for stat_type: String in stat_selected_icons:
		var selected_icon: Dictionary = stat_selected_icons[stat_type]

		if selected_icon["type"] == "none":
			continue

		var stat_index: int = _get_stat_index(stat_type)

		if stat_index == -1:
			continue

		var large_stat_screen_background: ColorRect = _get_large_background_for_icon(
			selected_icon["type"],
			stat_index
		)

		if large_stat_screen_background == null:
			continue

		set_position(
			selected_icon["start"],
			selected_icon["stop"],
			large_stat_screen_background,
			selected_icon["direction"],
			840.0
		)


func small_stat_display_get_spare(stat_type: String) -> void:
	reset_small_screens()
	
	var stat_selected_icons: Dictionary = handle_spare_symbols.selected_stat_selected_icons
	
	if not stat_selected_icons.has(stat_type):
		push_error("No spare icon data for stat type: " + stat_type)
		return
	
	var selected_icon: Dictionary = stat_selected_icons[stat_type]
	
	if selected_icon["type"] == "none":
		return
	
	var small_stat_screen_background: ColorRect = _get_small_background_for_icon(
		selected_icon["type"]
	)
	
	if small_stat_screen_background == null:
		return
	
	set_position(
		selected_icon["start"],
		selected_icon["stop"],
		small_stat_screen_background,
		selected_icon["direction"],
		840.0
	)


func _get_stat_index(stat_type: String) -> int:
	match stat_type:
		"strength":
			return 0
		"intelligence":
			return 1
		"community":
			return 2
		_:
			push_error("Invalid stat type: " + stat_type)
			return -1


func _get_large_background_for_icon(icon_type: String, stat_index: int) -> ColorRect:
	match icon_type:
		"defect":
			return defect_symbols.large_stat_screen_defect_background[stat_index]
		"energy":
			return energy_symbols.large_stat_screen_energy_background[stat_index]
		"good_mutation":
			return good_mutation_symbols.large_stat_screen_good_mutation_background[stat_index]
		"bad_mutation":
			return bad_mutation_symbols.large_stat_screen_bad_mutation_background[stat_index]
		_:
			push_error("Invalid large icon type: " + icon_type)
			return null


func _get_small_background_for_icon(icon_type: String) -> ColorRect:
	match icon_type:
		"defect":
			return defect_symbols.small_stat_screens_defect_background
		"energy":
			return energy_symbols.small_stat_screens_energy_background
		"good_mutation":
			return good_mutation_symbols.small_stat_screens_good_mutation_background
		"bad_mutation":
			return bad_mutation_symbols.small_stat_screens_bad_mutation_background
		_:
			push_error("Invalid small icon type: " + icon_type)
			return null


func set_position(
	pos_min: float,
	pos_max: float,
	stat_background: ColorRect,
	direction: String,
	override_max_width: float = -1.0
) -> void:
	var total_stat_value: float = IVCellCreator.total_stat_value
	
	var max_width: float
	
	if override_max_width > 0.0:
		max_width = override_max_width
	else:
		max_width = stat_background.get_parent().size.x
	
	var start_percent_of_total: float = clamp(
		pos_min / total_stat_value,
		0.0,
		1.0
	)

	var end_percent_of_total: float = clamp(
		pos_max / total_stat_value,
		0.0,
		1.0
	)

	var start_x: float = max_width * start_percent_of_total
	var end_x: float = max_width * end_percent_of_total

	var background_width: float = end_x - start_x
	background_width = max(background_width, 0.0)

	stat_background.position.x = start_x - 10.0
	stat_background.size.x = background_width

	stat_background._place_sprite(direction)


func reset_large_screens() -> void:
	for background: ColorRect in defect_symbols.large_stat_screen_defect_background:
		background._reset()
	
	for background: ColorRect in energy_symbols.large_stat_screen_energy_background:
		background._reset()
	
	for background: ColorRect in good_mutation_symbols.large_stat_screen_good_mutation_background:
		background._reset()
	
	for background: ColorRect in bad_mutation_symbols.large_stat_screen_bad_mutation_background:
		background._reset()


func reset_small_screens() -> void:
	defect_symbols.small_stat_screens_defect_background._reset()
	energy_symbols.small_stat_screens_energy_background._reset()
	good_mutation_symbols.small_stat_screens_good_mutation_background._reset()
	bad_mutation_symbols.small_stat_screens_bad_mutation_background._reset()
