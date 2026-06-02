extends Node

# componnets
# left cell checkmarks
@onready var left_strength_checkmark : Sprite2D = $"../../Symbols/CheckMarks/LeftCellCheckmarks/StrengthCheckmark"
@onready var left_intelligence_checkmark : Sprite2D = $"../../Symbols/CheckMarks/LeftCellCheckmarks/IntelligenceCheckmark"
@onready var left_community_checkmark : Sprite2D = $"../../Symbols/CheckMarks/LeftCellCheckmarks/CommunityCheckmark"
# right cell checkmarks
@onready var right_strength_checkmark : Sprite2D = $"../../Symbols/CheckMarks/RightCellCheckmarks/StrengthCheckmark"
@onready var right_intelligence_checkmark : Sprite2D = $"../../Symbols/CheckMarks/RightCellCheckmarks/IntelligenceCheckmark"
@onready var right_community_checkmark : Sprite2D = $"../../Symbols/CheckMarks/RightCellCheckmarks/CommunityCheckmark"

func _handle_checkmarks(panel_side : String, cell : BrainCell) :
	
	# if cell is null (nothing on panel) hide checkmarks
	if not cell :
		hide_check_marks(panel_side)
		return
	
	
	var target = GLCellManagerBus.target_cell_refrence
	
	var display_strength_check : bool = check_stat_radius_to_target_stat(
		cell.strength.value,
		target.strength.value
	)
	
	var display_intelligence_check : bool = check_stat_radius_to_target_stat(
		cell.intelligence.value,
		target.intelligence.value
	)
	
	var display_community_check : bool = check_stat_radius_to_target_stat(
		cell.community.value,
		target.community.value
	)
	
	if cell.strength.hidden:
		display_strength_check = false	
	
	if cell.intelligence.hidden:
		display_intelligence_check = false
	
	if cell.community.hidden:
		display_community_check = false
	
	
	# LEFT PANEL
	if panel_side == "left":
		left_strength_checkmark.visible = display_strength_check
		left_intelligence_checkmark.visible = display_intelligence_check
		left_community_checkmark.visible = display_community_check
	
	# RIGHT PANEL
	elif panel_side == "right":
		right_strength_checkmark.visible = display_strength_check
		right_intelligence_checkmark.visible = display_intelligence_check
		right_community_checkmark.visible = display_community_check

func check_stat_radius_to_target_stat(cell_stat, target_stat) -> bool :
	return abs(cell_stat - target_stat) <= 20

func hide_check_marks(panel_side : String) :
	if panel_side == 'right' :
		right_strength_checkmark.visible = false
		right_intelligence_checkmark.visible = false
		right_community_checkmark.visible = false
	
	if panel_side == 'left' :
		left_strength_checkmark.visible = false
		left_intelligence_checkmark.visible = false
		left_community_checkmark.visible = false
