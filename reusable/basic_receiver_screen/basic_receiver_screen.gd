extends Node

## lets screen know if to showcase min/max and current value labels 
@export var disable_progress_labels : bool = true
@onready var progress_labels : Control = $StatDisplay/ProgressLabels

## whenever a cell == null. can choose to show another scene
@export var invalid_cell_placeholder_screen: PackedScene = null
var placeholder_screen_instance : Node

# helper components
@onready var reset_stat_display : Node = $ResetStatDisplay
@onready var handle_disabled_stats : Node = $HandleDisabledStats
@onready var display_target_cell : Node = $DisplayTargetCell
@onready var display_cell : Node = $DisplayCell

# display components
@onready var strength_bar : Sprite2D = $StatDisplay/ProgressBars/StrengthBar
@onready var intelligence_bar : Sprite2D = $StatDisplay/ProgressBars/IntelligenceBar
@onready var community_bar : Sprite2D = $StatDisplay/ProgressBars/CommunityBar


func _ready() -> void:
	strength_bar.material = strength_bar.material.duplicate()
	intelligence_bar.material = intelligence_bar.material.duplicate()
	community_bar.material = community_bar.material.duplicate()

	if disable_progress_labels:
		progress_labels.visible = false

	if invalid_cell_placeholder_screen:
		toggle_placeholder_screen(true)


func _handle_brain_cell_recieved(cell : BrainCell) -> void:
	reset_stat_display._reset(disable_progress_labels)

	if cell == null:
		toggle_placeholder_screen(true)
		return

	toggle_placeholder_screen(false)

	var cell_stats_dic = {
		"strength": cell.strength,
		"intelligence": cell.intelligence,
		"community": cell.community
	}

	cell_stats_dic = handle_disabled_stats._handle(cell_stats_dic)

	if cell.is_target_cell:
		display_target_cell._display_target(cell)
	else:
		display_cell._display_cell(cell, cell_stats_dic)

func toggle_placeholder_screen(show : bool) -> void:
	if show:
		if is_instance_valid(placeholder_screen_instance):
			return

		placeholder_screen_instance = invalid_cell_placeholder_screen.instantiate()

		add_child(placeholder_screen_instance)
		move_child(placeholder_screen_instance, get_child_count() - 1)

	else:
		if not is_instance_valid(placeholder_screen_instance):
			return

		placeholder_screen_instance.queue_free()
		placeholder_screen_instance = null
	
