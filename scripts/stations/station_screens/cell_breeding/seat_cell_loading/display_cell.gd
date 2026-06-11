extends Node

@onready var defect_bars_parent : Array[TextureProgressBar] = [
	$"../LoadedCellDisplay/DefectBars/DefectStrengthBar",
	$"../LoadedCellDisplay/DefectBars/DefectIntelligenceBar",
	$"../LoadedCellDisplay/DefectBars/DefectCommunityBar"
]
@onready var progress_bars_parent : Array[Sprite2D] = [
	$"../LoadedCellDisplay/ProgressBars/StrengthBar",
 	$"../LoadedCellDisplay/ProgressBars/IntelligenceBar",
	$"../LoadedCellDisplay/ProgressBars/CommunityBar"
]
@onready var progress_bars_labels : Array[Label] = [
	$"../LoadedCellDisplay/ProgressBars/StengthLabel",
	$"../LoadedCellDisplay/ProgressBars/IntelligenceLabel",
	$"../LoadedCellDisplay/ProgressBars/CommunityLabel"
]

@onready var hide_stats_sprite_parent : Array[Sprite2D] = [
	$"../LoadedCellDisplay/HideStats/StrengthHide",
	$"../LoadedCellDisplay/HideStats/IntelligenceHide",
	$"../LoadedCellDisplay/HideStats/CommunityHide"
]
@onready var off_display_labels_parent : Array[Label] = [
	$"../LoadedCellDisplay/OffDisableLabels/StrengthOffLabel",
	$"../LoadedCellDisplay/OffDisableLabels/IntelligenceOffLabel",
	$"../LoadedCellDisplay/OffDisableLabels/CommunityOffLabel"
]

var active_brain_cell : BrainCell 

func _ready() -> void:
	for progress_bar : Sprite2D in progress_bars_parent :
		progress_bar.material = progress_bar.material.duplicate()


func _display(brain_cell : BrainCell) -> void:
	active_brain_cell = brain_cell

	var enabled_stats : Array[String] = [
		"strength",
		"intelligence",
		"community",
	]

	enabled_stats = find_disabled_stats(enabled_stats)
	
	# helper
	set_defect_max_value()
	
	for enabled_stat : String in enabled_stats :	
		display_hidden(enabled_stat)
		display_defect(enabled_stat)
		display_clean(enabled_stat)
	
	

func find_disabled_stats(enabled_stats : Array[String]) -> Array[String]:
	if not active_brain_cell.strength.enabled:
		enabled_stats.erase("strength")
		toggle_disable_label('strength')

	if not active_brain_cell.intelligence.enabled:
		enabled_stats.erase("intelligence")
		toggle_disable_label('intelligence')

	if not active_brain_cell.community.enabled:
		enabled_stats.erase("community")
		toggle_disable_label('community')

	return enabled_stats

func set_defect_max_value() :		
	# set max value for each bar
	var max_value : float = IVCellCreator.max_stat_value
	for defect_bar : TextureProgressBar in defect_bars_parent :
		defect_bar.max_value = max_value

func toggle_disable_label(type : String) :
	match type :
		'strength' :
			off_display_labels_parent[0].visible = true
			progress_bars_labels[0].modulate.a = 0.4
		'intelligence' :
			off_display_labels_parent[1].visible = true
			progress_bars_labels[1].modulate.a = 0.4
		'community' :		
			off_display_labels_parent[2].visible = true
			progress_bars_labels[2].modulate.a = 0.4
		_ : 
			push_error('cant find disable label for type : ', type)
		
func display_hidden(stat_type : String) :

	match stat_type : 
		'strength' :
			if active_brain_cell.strength.hidden :
				hide_stats_sprite_parent[0].visible = true
		'intelligence' :
			if active_brain_cell.intelligence.hidden :
				hide_stats_sprite_parent[1].visible = true
		'community' :
			if active_brain_cell.community.hidden :
				hide_stats_sprite_parent[2].visible = true
				
func display_defect(stat_type : String) :
	
	match stat_type :
		'strength' :
			defect_bars_parent[0].value = active_brain_cell.strength.defect
		'intelligence' :
			defect_bars_parent[1].value = active_brain_cell.intelligence.defect		
		'community' :
			defect_bars_parent[2].value = active_brain_cell.community.defect		

func display_clean(stat_type : String) -> void:

	var target_cell : BrainCell = GLCellManagerBus.target_cell_refrence
	var selected_bar : Sprite2D
	var target_value : float = 0.0
	var cell_value : float = 0.0

	match stat_type:
		"strength":
			selected_bar = progress_bars_parent[0]
			cell_value = active_brain_cell.strength.value
			target_value = target_cell.strength.value
		"intelligence":
			selected_bar = progress_bars_parent[1]
			cell_value = active_brain_cell.intelligence.value
			target_value = target_cell.intelligence.value
		"community":
			selected_bar = progress_bars_parent[2]
			cell_value = active_brain_cell.community.value
			target_value = target_cell.community.value

	var max_val = float(IVCellCreator.max_stat_value)

	selected_bar.material.set_shader_parameter(
		"prisoner_value",
		cell_value / max_val
	)

	selected_bar.material.set_shader_parameter(
		"target_value",
		target_value / max_val
	)
