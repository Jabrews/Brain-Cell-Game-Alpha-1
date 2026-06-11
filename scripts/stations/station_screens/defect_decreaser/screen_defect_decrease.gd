extends Node

# components
@onready var no_cell_label : Label = $NoCell
@onready var defect_display : Control = $DefectDisplay
@onready var defect_strength_bar : Sprite2D = $DefectDisplay/DefectStrengthBar
@onready var defect_intelligence_bar : Sprite2D = $DefectDisplay/DefectIntelligenceBar
@onready var defect_community_bar : Sprite2D = $DefectDisplay/DefectCommunityBar
@onready var strength_hidden : Sprite2D = $DefectDisplay/StrengthHide
@onready var intelligence_hidden : Sprite2D = $DefectDisplay/IntelligenceHide
@onready var community_hidden : Sprite2D = $DefectDisplay/CommunityHide
@onready var strength_label : Label = $DefectDisplay/Label1
@onready var intelligencd_label : Label = $DefectDisplay/Label2
@onready var community_label : Label = $DefectDisplay/Label3


func _ready() -> void:
	defect_strength_bar.material = defect_strength_bar.material.duplicate()
	defect_intelligence_bar.material = defect_intelligence_bar.material.duplicate()
	defect_community_bar.material = defect_community_bar.material.duplicate()


func _display_defect_decrease_preview(brain_cell : BrainCell) -> void:
	if brain_cell == null:
		no_cell_label.visible = true
		defect_display.visible = false
		reset_defect_bars()
		return

	no_cell_label.visible = false
	defect_display.visible = true
	load_defect_bars(brain_cell)


func load_defect_bars(brain_cell : BrainCell) -> void:

	reset_display_state()

	var defect_decrease : float = IVCellDefectDecreaser.decrease_amount
	var max_value : float = float(IVCellCreator.max_stat_value)

	# strength
	var strength_new = max(0.0, brain_cell.strength.defect - defect_decrease)

	if brain_cell.strength.enabled:
		if brain_cell.strength.hidden:
			strength_hidden.visible = true
		else:
			defect_strength_bar.material.set_shader_parameter(
				"prior_defect_value",
				brain_cell.strength.defect / max_value
			)
			defect_strength_bar.material.set_shader_parameter(
				"new_defect_value",
				strength_new / max_value
			)
	else:
		defect_strength_bar.visible = false
		strength_label.visible = false


	# intelligence
	var intelligence_new = max(0.0, brain_cell.intelligence.defect - defect_decrease)

	if brain_cell.intelligence.enabled:
		if brain_cell.intelligence.hidden:
			intelligence_hidden.visible = true
		else:
			defect_intelligence_bar.material.set_shader_parameter(
				"prior_defect_value",
				brain_cell.intelligence.defect / max_value
			)
			defect_intelligence_bar.material.set_shader_parameter(
				"new_defect_value",
				intelligence_new / max_value
			)
	else:
		defect_intelligence_bar.visible = false
		intelligencd_label.visible = false


	# community
	var community_new = max(0.0, brain_cell.community.defect - defect_decrease)

	if brain_cell.community.enabled:
		if brain_cell.community.hidden:
			community_hidden.visible = true
		else:
			defect_community_bar.material.set_shader_parameter(
				"prior_defect_value",
				brain_cell.community.defect / max_value
			)
			defect_community_bar.material.set_shader_parameter(
				"new_defect_value",
				community_new / max_value
			)
	else:
		defect_community_bar.visible = false
		community_label.visible = false
		
		
	check_for_defect_gone_to_zero()
	
	
func reset_defect_bars() -> void:

	reset_display_state()

	for bar in [
		defect_strength_bar,
		defect_intelligence_bar,
		defect_community_bar
	]:
		bar.material.set_shader_parameter("prior_defect_value", 0.0)
		bar.material.set_shader_parameter("new_defect_value", 0.0)


# whenever new decreased defect goes to 0 can look confusing to leave 'past' bar.
# for this reason set both to zero
func check_for_defect_gone_to_zero() -> void:
	_check_bar_zero(defect_strength_bar)
	_check_bar_zero(defect_intelligence_bar)
	_check_bar_zero(defect_community_bar)


func _check_bar_zero(bar : Sprite2D) -> void:
	var new_defect_value : float = bar.material.get_shader_parameter("new_defect_value")

	if is_equal_approx(new_defect_value, 0.0):
		bar.material.set_shader_parameter("prior_defect_value", 0.0)
		bar.material.set_shader_parameter("new_defect_value", 0.0)
	
	
func reset_display_state() -> void:

	strength_hidden.visible = false
	intelligence_hidden.visible = false
	community_hidden.visible = false

	defect_strength_bar.visible = true
	defect_intelligence_bar.visible = true
	defect_community_bar.visible = true

	strength_label.visible = true
	intelligencd_label.visible = true
	community_label.visible = true
