extends Node

# componnets
@onready var total_hidden_label : Control = $TotalLabel
# very hacky but we use this to refrence our real functionality
@onready var reduce_hidden_quanitiy : Node = $"../../../../../../../GameManager/CellCreator/AssembleCells/HelperHidden/ReduceHiddenQuanitiy"
@onready var parent_prisoner_profiler : Node3D = $"../../../.."

@onready var max_label : Label = $MaxLabel
@onready var max_arrow : Sprite2D = $MaxArrow

var max_stats_to_hide : int 

var shake_tween : Tween


func _ready() -> void: 
	GLGameManagerBus.connect('proceed_next_energy_turn', _handle_energy_turn_changed)
	
func _handle_energy_turn_changed() :
	total_hidden_label.text = str(IVHiddenStats.max_stats_to_hide)
	max_stats_to_hide = IVHiddenStats.max_stats_to_hide
	
	max_label.text = str(IVHiddenStats.max_stats_to_hide)
	
	

func _profiler_changed_hidden_stat() :
	
	var potential_max_stats_to_hide : int = max_stats_to_hide
	
	potential_max_stats_to_hide = prisoner_quanity_changed(potential_max_stats_to_hide)
	potential_max_stats_to_hide = stat_disabled(potential_max_stats_to_hide)
	
	total_hidden_label.text = str(potential_max_stats_to_hide)
	
	check_for_max_label(potential_max_stats_to_hide)
	check_for_hidden_stat_min(potential_max_stats_to_hide)
	

func prisoner_quanity_changed(potential_max_stats_to_hide : int) :
	var quanity = parent_prisoner_profiler.prisoner_quantity
	potential_max_stats_to_hide = reduce_hidden_quanitiy._handle_reduce_quanity(quanity, potential_max_stats_to_hide)
	return potential_max_stats_to_hide
	
	
func stat_disabled(potential_max_stats_to_hide : int) :
	# we flip the disabled because its looking for 'enabled'
	potential_max_stats_to_hide = reduce_hidden_quanitiy._handle_reduce_disabled(
		!parent_prisoner_profiler.strength_disabled,
		!parent_prisoner_profiler.intelligence_disabled,
		!parent_prisoner_profiler.community_disabled,
		potential_max_stats_to_hide
	)
	
	return potential_max_stats_to_hide
	
	
func check_for_max_label(potential_max_stats_to_hide : int) :
	if potential_max_stats_to_hide != IVHiddenStats.max_stats_to_hide :
		max_label.visible = true
		max_arrow.visible = true
	else :
		max_label.visible = false 
		max_arrow.visible = false 

	
func check_for_hidden_stat_min(potential_max_stats_to_hide : int) :
	
	# do not display warning if original max is already 1
	if potential_max_stats_to_hide == 1 and max_stats_to_hide != 1 :
		
		total_hidden_label.add_theme_color_override("font_color", Color.GREEN_YELLOW)
		
		# prevent stacking tweens
		if shake_tween:
			shake_tween.kill()
		
		var start_pos = total_hidden_label.position
		
		shake_tween = create_tween()
		shake_tween.set_loops()
		shake_tween.tween_property(
			total_hidden_label,
			"position:x",
			start_pos.x + 4,
			0.05
		)
		shake_tween.tween_property(
			total_hidden_label,
			"position:x",
			start_pos.x - 4,
			0.05
		)
		shake_tween.tween_property(
			total_hidden_label,
			"position:x",
			start_pos.x,
			0.05
		)
		
	else:
		
		total_hidden_label.add_theme_color_override("font_color", Color.WHITE)
		
		if shake_tween:
			shake_tween.kill()
			shake_tween = null
	
