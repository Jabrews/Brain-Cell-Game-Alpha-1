extends Node

var active_cell : BrainCell
var parent_cell_1 : BrainCell
var parent_cell_2 : BrainCell

const STAT_TYPES : Array[String] = [
	"strength",
	"intelligence",
	"community"
]

@onready var clean_bars : Array[Sprite2D] = [
	$StatDisplay/ProgressBars/StrengthBar,
	$StatDisplay/ProgressBars/IntelligenceBar,
	$StatDisplay/ProgressBars/CommunityBar
]

@onready var clean_bar_labels : Array[Label] = [
	$StatDisplay/ProgressBars/StengthLabel,
	$StatDisplay/ProgressBars/IntelligenceLabel,
	$StatDisplay/ProgressBars/CommunityLabel
]

@onready var defect_bars : Array[Sprite2D] = [
	$StatDisplay/DefectBars/StrengthDefect,
	$StatDisplay/DefectBars/IntelligenceDefect,
	$StatDisplay/DefectBars/CommunityDefect
]

@onready var disabled_labels : Array[Label] = [
	$StatDisplay/OffDisableLabels/StrengthOffLabel,
	$StatDisplay/OffDisableLabels/IntelligenceOffLabel,
	$StatDisplay/OffDisableLabels/CommunityOffLabel
]

@onready var hide_sprites : Array[Sprite2D] = [
	$StatDisplay/HideStats/StrengthHide,
	$StatDisplay/HideStats/IntelligenceHide,
	$StatDisplay/HideStats/CommunityHide
]


func _ready() -> void:
	_duplicate_bar_materials()
	reset_preview()


func _duplicate_bar_materials() -> void:
	for bar : Sprite2D in clean_bars:
		if bar.material:
			bar.material = bar.material.duplicate()
		else:
			push_error("Clean bar missing material: " + str(bar.name))

	for bar : Sprite2D in defect_bars:
		if bar.material:
			bar.material = bar.material.duplicate()
		else:
			push_error("Defect bar missing material: " + str(bar.name))


func _display_simulated_cell(
	cell_1 : BrainCell,
	cell_2 : BrainCell,
	simulated_cell : BrainCell
) -> void:

	parent_cell_1 = cell_1
	parent_cell_2 = cell_2
	active_cell = simulated_cell

	if not active_cell:
		reset_preview()
		return

	if not parent_cell_1 or not parent_cell_2:
		push_error("Cannot display simulated cell preview without both parent cells.")
		reset_preview()
		return

	_reset_ui_only()

	var display_stats : Array[String] = [
		"strength",
		"intelligence",
		"community"
	]

	display_stats = find_truly_disabled_stats(display_stats)

	for stat_type : String in display_stats:
		display_hidden(stat_type)
		display_clean(stat_type)
		display_defect(stat_type)


func find_truly_disabled_stats(display_stats : Array[String]) -> Array[String]:
	# Only disabled in preview if BOTH parent cells do not have the stat.

	if not parent_cell_1.strength.enabled and not parent_cell_2.strength.enabled:
		display_stats.erase("strength")
		toggle_disable_label("strength")
		clear_stat_bars("strength")

	if not parent_cell_1.intelligence.enabled and not parent_cell_2.intelligence.enabled:
		display_stats.erase("intelligence")
		toggle_disable_label("intelligence")
		clear_stat_bars("intelligence")

	if not parent_cell_1.community.enabled and not parent_cell_2.community.enabled:
		display_stats.erase("community")
		toggle_disable_label("community")
		clear_stat_bars("community")

	return display_stats


func toggle_disable_label(type : String) -> void:
	var index : int = get_stat_index(type)

	if index == -1:
		push_error("Cannot find disable label for type: " + type)
		return

	disabled_labels[index].visible = true
	clean_bar_labels[index].modulate.a = 0.4


func display_hidden(stat_type : String) -> void:
	var index : int = get_stat_index(stat_type)

	if index == -1:
		push_error("Cannot display hidden stat for type: " + stat_type)
		return

	hide_sprites[index].visible = is_stat_hidden(stat_type)


func is_stat_hidden(stat_type : String) -> bool:
	match stat_type:
		"strength":
			return (
				parent_cell_1.strength.hidden
				or parent_cell_2.strength.hidden
				or active_cell.strength.hidden
			)

		"intelligence":
			return (
				parent_cell_1.intelligence.hidden
				or parent_cell_2.intelligence.hidden
				or active_cell.intelligence.hidden
			)

		"community":
			return (
				parent_cell_1.community.hidden
				or parent_cell_2.community.hidden
				or active_cell.community.hidden
			)

		_:
			push_error("Cannot check hidden stat for type: " + stat_type)
			return false


func display_clean(stat_type : String) -> void:
	var target_cell : BrainCell = GLCellManagerBus.target_cell_refrence

	if not target_cell:
		push_error("No target cell found for simulated cell preview.")
		return

	var index : int = get_stat_index(stat_type)

	if index == -1:
		push_error("Cannot display clean stat for type: " + stat_type)
		return

	var selected_bar : Sprite2D = clean_bars[index]

	if not selected_bar.material:
		push_error("Missing material on clean bar: " + str(selected_bar.name))
		return

	var cell_value : float = get_active_clean_value(stat_type)
	var target_value : float = get_target_clean_value(stat_type, target_cell)
	var start_value : float = get_parent_start_clean_value(stat_type)

	var max_val : float = float(IVCellCreator.max_stat_value)

	if max_val <= 0.0:
		push_error("IVCellCreator.max_stat_value must be greater than 0.")
		return

	selected_bar.visible = true

	selected_bar.material.set_shader_parameter(
		"prisoner_value",
		clampf(cell_value / max_val, 0.0, 1.0)
	)

	selected_bar.material.set_shader_parameter(
		"target_value",
		clampf(target_value / max_val, 0.0, 1.0)
	)

	selected_bar.material.set_shader_parameter(
		"start_value",
		clampf(start_value / max_val, 0.0, 1.0)
	)


func display_defect(stat_type : String) -> void:
	var index : int = get_stat_index(stat_type)

	if index == -1:
		push_error("Cannot display defect stat for type: " + stat_type)
		return

	var selected_bar : Sprite2D = defect_bars[index]

	if not selected_bar.material:
		push_error("Missing material on defect bar: " + str(selected_bar.name))
		return

	var defect_value : float = get_active_defect_value(stat_type)
	var start_defect_value : float = get_parent_start_defect_value(stat_type)

	var max_val : float = float(IVCellCreator.max_stat_value)

	if max_val <= 0.0:
		push_error("IVCellCreator.max_stat_value must be greater than 0.")
		return

	selected_bar.visible = true

	selected_bar.material.set_shader_parameter(
		"stat_defect_value",
		clampf(defect_value / max_val, 0.0, 1.0)
	)

	selected_bar.material.set_shader_parameter(
		"start_value",
		clampf(start_defect_value / max_val, 0.0, 1.0)
	)


func get_parent_start_clean_value(stat_type : String) -> float:
	match stat_type:
		"strength":
			return get_highest_enabled_parent_value(
				parent_cell_1.strength,
				parent_cell_2.strength,
				"value"
			)

		"intelligence":
			return get_highest_enabled_parent_value(
				parent_cell_1.intelligence,
				parent_cell_2.intelligence,
				"value"
			)

		"community":
			return get_highest_enabled_parent_value(
				parent_cell_1.community,
				parent_cell_2.community,
				"value"
			)

		_:
			push_error("Cannot get parent start clean value for type: " + stat_type)
			return 0.0


func get_parent_start_defect_value(stat_type : String) -> float:
	match stat_type:
		"strength":
			return get_highest_enabled_parent_value(
				parent_cell_1.strength,
				parent_cell_2.strength,
				"defect"
			)

		"intelligence":
			return get_highest_enabled_parent_value(
				parent_cell_1.intelligence,
				parent_cell_2.intelligence,
				"defect"
			)

		"community":
			return get_highest_enabled_parent_value(
				parent_cell_1.community,
				parent_cell_2.community,
				"defect"
			)

		_:
			push_error("Cannot get parent start defect value for type: " + stat_type)
			return 0.0


func get_highest_enabled_parent_value(
	stat_1 : BrainCellStat,
	stat_2 : BrainCellStat,
	value_type : String
) -> float:

	if stat_1.enabled and stat_2.enabled:
		return max(
			get_stat_value_by_type(stat_1, value_type),
			get_stat_value_by_type(stat_2, value_type)
		)

	if stat_1.enabled:
		return get_stat_value_by_type(stat_1, value_type)

	if stat_2.enabled:
		return get_stat_value_by_type(stat_2, value_type)

	return 0.0


func get_stat_value_by_type(
	stat : BrainCellStat,
	value_type : String
) -> float:

	match value_type:
		"value":
			return stat.value

		"defect":
			return stat.defect

		_:
			push_error("Invalid stat value type: " + value_type)
			return 0.0


func get_active_clean_value(stat_type : String) -> float:
	match stat_type:
		"strength":
			return active_cell.strength.value

		"intelligence":
			return active_cell.intelligence.value

		"community":
			return active_cell.community.value

		_:
			push_error("Cannot get active clean value for type: " + stat_type)
			return 0.0


func get_active_defect_value(stat_type : String) -> float:
	match stat_type:
		"strength":
			return active_cell.strength.defect

		"intelligence":
			return active_cell.intelligence.defect

		"community":
			return active_cell.community.defect

		_:
			push_error("Cannot get active defect value for type: " + stat_type)
			return 0.0


func get_target_clean_value(
	stat_type : String,
	target_cell : BrainCell
) -> float:

	match stat_type:
		"strength":
			return target_cell.strength.value

		"intelligence":
			return target_cell.intelligence.value

		"community":
			return target_cell.community.value

		_:
			push_error("Cannot get target clean value for type: " + stat_type)
			return 0.0


func clear_stat_bars(stat_type : String) -> void:
	var index : int = get_stat_index(stat_type)

	if index == -1:
		push_error("Cannot clear stat bars for type: " + stat_type)
		return

	_clear_clean_bar(index)
	_clear_defect_bar(index)


func _clear_clean_bar(index : int) -> void:
	var selected_bar : Sprite2D = clean_bars[index]

	if not selected_bar.material:
		return

	selected_bar.material.set_shader_parameter(
		"prisoner_value",
		0.0
	)

	selected_bar.material.set_shader_parameter(
		"target_value",
		0.0
	)

	selected_bar.material.set_shader_parameter(
		"start_value",
		0.0
	)


func _clear_defect_bar(index : int) -> void:
	var selected_bar : Sprite2D = defect_bars[index]

	if not selected_bar.material:
		return

	selected_bar.material.set_shader_parameter(
		"stat_defect_value",
		0.0
	)

	selected_bar.material.set_shader_parameter(
		"start_value",
		0.0
	)


func reset_preview() -> void:
	active_cell = null
	parent_cell_1 = null
	parent_cell_2 = null

	_reset_ui_only()

	for stat_type : String in STAT_TYPES:
		clear_stat_bars(stat_type)


func _reset_ui_only() -> void:
	for hide_sprite : Sprite2D in hide_sprites:
		hide_sprite.visible = false

	for disable_label : Label in disabled_labels:
		disable_label.visible = false

	for clean_bar_label : Label in clean_bar_labels:
		clean_bar_label.modulate.a = 1.0


func get_stat_index(stat_type : String) -> int:
	match stat_type:
		"strength":
			return 0

		"intelligence":
			return 1

		"community":
			return 2

		_:
			return -1
