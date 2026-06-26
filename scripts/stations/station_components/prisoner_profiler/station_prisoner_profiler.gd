extends Node

var selected_stat : String = ''

var current_prisoner_quanity : int = 0

var strength_value : int = 0
var intelligence_value : int = 0
var community_value : int = 0

var strength_enabled : bool = true
var intelligence_enabled : bool = true
var community_enabled : bool = true

# lock
var strength_lock_starting_value : int = 0
var intelligence_lock_starting_value : int = 0
var community_lock_starting_value : int = 0
# TODO use for finale assembler directions. prevent 
var stat_values_inside_lock_range = {
	'strength' : false,
	'intelligence' : false,
	'community' : false,
}
# innaccesibile
var inaccessible_starting_value : int = 0




# componnets
# display componnets
@onready var screen_large_stat_displays : Array[Node2D] = [
	$StatDisplay/StatPanels/StrengthStatPanel/CapControlTv/SubViewport/LargeStatDisplay,
	$StatDisplay/StatPanels/IntelligenceStatPanel/CapControlTv/SubViewport/LargeStatDisplay,
	$StatDisplay/StatPanels/CommunityStatPanel/CapControlTv/SubViewport/LargeStatDisplay
]
@onready var screen_small_stat_display : Node2D = $ControlInterface/SmallStatDisplay/TvFrontPanel/SubViewport/SmallStatDisplay
@onready var control_interface : Node3D = $ControlInterface
# extra
@onready var on_off_btn : StaticBody3D = $ControlInterface/Control/OnOffBtn

# helpers
# symbols
@onready var handle_inaccesible : Node = $Logic/Symbols/HandleInaccessible
@onready var handle_spare_symbols: Node = $Logic/Symbols/HandleSpareSymbols
@onready var spare_symbol_evaluator : Node = $Logic/Symbols/HandleSpareSymbols/SpareSymbolEvaluator
@onready var handle_lock : Node = $Logic/Symbols/HandleLock
# energy
@onready var handle_energy : Node = $Logic/HandleEnergy
# extra
@onready var util_stat_type_to : Node = $Logic/UtilStatTypeTo
@onready var handle_cycle_stat : Node = $Logic/HandleCycleStat
@onready var audio_manager : Node3D = $ProfilerAudioManager


func _ready() -> void:
	GLGameManagerBus.connect('proceed_next_energy_turn', _handle_next_turn)
	GLGameManagerBus.connect('process_next_round', _handle_next_round)
	
	# quick delay on startup for cell creation logic 
	await get_tree().create_timer(1.0).timeout
	handle_inaccesible._generate_inaccessible()
	handle_lock._generate_locks()
	handle_spare_symbols._generate_spare()
	

func _update_prisoner_quanity(new_prisoner_quanity : int) :
	current_prisoner_quanity = new_prisoner_quanity
	
	# update energy
	handle_energy._update_energy_player_pressed_prisoner_quanity_btn(current_prisoner_quanity)
	
	# audio
	GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
	
	

func update_selected_stat(stat_type : String) :
	
	audio_manager.play_cycle_stat()
	
	selected_stat = stat_type
	on_off_btn.update_toggle_off_btn()
	# the only display componnets we need to update if it has none
	var stat_value = util_stat_type_to.stat_type_to_value(stat_type)
	var stat_enabled = util_stat_type_to.stat_type_to_enabled(stat_type)
	
	screen_small_stat_display._update_stat(stat_type, stat_value, stat_enabled)
	control_interface._update_stat(stat_type, stat_value, stat_enabled)
	


func _handle_stat_value_changed(stat_type : String, new_value : int) :
	
	# prevent disabled stats from incrementing
	var stat_enabled = util_stat_type_to.stat_type_to_enabled(stat_type)
	
	if stat_enabled == false :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
		
	# audio
	audio_manager.play_increment_sound()
#	
	if new_value <= 0 :
		new_value = 0
	
	## invalid stat checking ##
	if new_value >= inaccessible_starting_value :
		new_value = inaccessible_starting_value
	###########################
	
	
	
	## lock checking ##
	var lock_limit : float = util_stat_type_to.stat_type_to_lock_limit(stat_type)
	var lock_soft_range = IVPrisonerProfiler.stat_increment_amount
	
	 #If close to the lock, but not past it, clamp right before the lock.
	if lock_soft_range == 10 :
		if new_value < lock_limit and new_value >= lock_limit - lock_soft_range:
			@warning_ignore("narrowing_conversion")
			new_value = lock_limit - 1
	elif lock_soft_range == 20 :
		if new_value < lock_limit and new_value >= lock_limit - lock_soft_range:
			@warning_ignore("narrowing_conversion")
			new_value = lock_limit - 5
	
		
	stat_values_inside_lock_range[stat_type] = new_value >= lock_limit
	
	if stat_values_inside_lock_range[stat_type]:
		GLPrisonerProfilerComponentsBus.emit_signal(
			'station_feedback_requested',
			'shake_lock',
			{'stat_type' : stat_type}
		)
		audio_manager.play_lock_shake()
	###################
	
	## spare smymbol evalutor ##	
	spare_symbol_evaluator._handle_value_changed(
		selected_stat,
		new_value, # new value
		util_stat_type_to.stat_type_to_value(selected_stat) # old value
	)
	#############################
	
	
	
	match stat_type :
		'strength' :
			strength_value = new_value
		'intelligence' :
			intelligence_value = new_value
		'community' :
			community_value = new_value
		
	# update energy
	handle_energy._update_energy_stat_value_used(stat_type, new_value)
		
	update_display_componnets(stat_type)


func _handle_toggle_stat_enabled() :
	
	# cant toggle when no stat selected
	if selected_stat == '':
		return
		
	var enabled_status : bool # quick hack for energy updater
	var last_value : float
	
	audio_manager.play_on_off_sound()
	
	match selected_stat:
		'strength' :
			strength_enabled = !strength_enabled
			enabled_status = strength_enabled
			last_value = strength_value
		'intelligence' :
			intelligence_enabled = !intelligence_enabled
			enabled_status = intelligence_enabled
			last_value = intelligence_value
		'community' :
			community_enabled = !community_enabled
			enabled_status = community_enabled
			last_value = community_value
	
	# update energy	
	handle_energy._update_energy_toggle_stat_value_enabled(selected_stat, enabled_status, last_value)
	
	update_display_componnets(selected_stat)



func update_display_componnets(stat_type : String) :
	match stat_type :
		'strength' :
			screen_large_stat_displays[0]._update_stat(strength_value, strength_enabled)
			screen_small_stat_display._update_stat(stat_type, strength_value, strength_enabled)
			control_interface._update_stat(stat_type, strength_value, strength_enabled)
		'intelligence' :
			screen_large_stat_displays[1]._update_stat(intelligence_value, intelligence_enabled)
			screen_small_stat_display._update_stat(stat_type, intelligence_value, intelligence_enabled)
			control_interface._update_stat(stat_type, intelligence_value, intelligence_enabled)
		'community' :
			screen_large_stat_displays[2]._update_stat(community_value, community_enabled)
			screen_small_stat_display._update_stat(stat_type , community_value, community_enabled)
			control_interface._update_stat(stat_type, community_value, community_enabled)

func _handle_next_turn() :
	reset_assembler()
	handle_lock._generate_locks()
	handle_spare_symbols._generate_spare()

func _handle_next_round() :
	handle_inaccesible._generate_inaccessible()
	handle_lock._generate_locks()
	handle_spare_symbols._generate_spare()
	
func reset_assembler() :
	strength_value = 0
	strength_enabled = true
	intelligence_value = 0
	intelligence_enabled = true
	community_value = 0
	community_enabled = true
	selected_stat = ''
	handle_cycle_stat.reset_active_mesh()
	screen_large_stat_displays[0]._update_stat(strength_value, strength_enabled)
	screen_large_stat_displays[1]._update_stat(intelligence_value, intelligence_enabled)
	screen_large_stat_displays[2]._update_stat(community_value, community_enabled)
	screen_small_stat_display._update_stat(selected_stat, 0.0, false)
	control_interface._update_stat(selected_stat, 0.0, false)


func handle_generate_btn_pressed() :
	
	###### CHECKING FOR ISSUES #######
	# prevent changing value if quanity not selected
	if current_prisoner_quanity == 0 :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		GLPrisonerProfilerComponentsBus.emit_signal(
			'station_feedback_requested',
			'error_prisoner_quanity', {}
		)
		audio_manager.play_feedback_sound()
		return
	
	# check if any stats in lock range
	for stat_lock in stat_values_inside_lock_range :
		if stat_values_inside_lock_range[stat_lock] :
			GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
			GLPrisonerProfilerComponentsBus.emit_signal(
				'station_feedback_requested',
				'error_locked_stat', {'stat_type' : stat_lock}
			)
			audio_manager.play_feedback_sound()
			return
	
	# check if all stats disabled
	if strength_enabled == false and intelligence_enabled == false and community_enabled == false:
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		GLPrisonerProfilerComponentsBus.emit_signal(
			'station_feedback_requested',
			'error_all_stats_disabled',
			{}
		)
		audio_manager.play_feedback_sound()
		return
	
	# check if we have enough energy
	if not handle_energy._check_if_energy_valid() :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		GLPrisonerProfilerComponentsBus.emit_signal(
			'station_feedback_requested',
			'error_not_enough_energy',
			{}
		)
		audio_manager.play_feedback_sound()
		return
	#######################################
		
	GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
	
	audio_manager.play_generate()
	
		
	var strength_stat_constructor = StatConstructor.new(
		"strength",
		strength_value,
		'none',
		strength_enabled
	)
	var intelligence_stat_constructor = StatConstructor.new(
		"intelligence",
		intelligence_value,
		'none',
		intelligence_enabled
	)
	var community_stat_constructor = StatConstructor.new(
		"community",
		community_value,
		'none',
		community_enabled
	)
	
	var prisoner_cell_constructor : CellConstructor = CellConstructor.new(
		current_prisoner_quanity,
		strength_stat_constructor,
		intelligence_stat_constructor,
		community_stat_constructor
	)
	
	GLCellCreatorBus.emit_signal(
		"create_prisoner_cells",
		prisoner_cell_constructor
	)
	
	GLPrisonerProfilerComponentsBus.emit_signal(
		'station_feedback_requested',
		'batch_created',
		{}
	)

	reset_assembler()
	
