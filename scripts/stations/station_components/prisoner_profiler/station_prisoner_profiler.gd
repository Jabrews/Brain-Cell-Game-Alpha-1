extends Node

# components
@onready var convert_alert_symbol : Node =$ConvertAlertSymbol
@onready var energy_spent_updater : Node = $EnergySpentUpdater
@onready var energy_panel : Node3D = $EnergyPanel
@onready var prisoner_quanitity_updater : Node = $PrisonerQuanityBtnUpdater
@onready var stat_control_panels : Array[Node3D] = [
	$StatControllPanels/StatControlPanel,
	$StatControllPanels/StatControlPanel2,
	$StatControllPanels/StatControlPanel3
]
@onready var screen_hidden_stat_quanity : Node2D = $HiddenQuanityTV/TvFrontPannel/SubViewport/ScreenHiddenStatQuanity
@onready var reset_componnets : Node = $ResetComponents
# screen helpers
@onready var handle_power_ran_out : Node = $HandlePowerRanOut
@onready var handle_prisoner_quanity_not_selected : Node = $HandlePrisonerQuanityNotSelected
@onready var handle_prisoners_just_created : Node = $HandlePrisonersJustCreated

var clean_strength : float = 0.0
var clean_intelligence: float = 0.0
var clean_community : float = 0.0
var strength_disabled : bool = false
var intelligence_disabled : bool = false
var community_disabled : bool = false

var strength_caution_active  : bool = false
var strength_warning_active  : bool = false
var intelligence_caution_active  : bool = false
var intelligence_warning_active  : bool = false
var community_caution_active  : bool = false
var community_warning_active  : bool = false

var prisoner_quantity : int = 0

var power_out : bool = false

func _ready() -> void:
	GLGameManagerBus.connect('proceed_next_energy_turn', _handle_energy_turn_changed)

func _handle_energy_turn_changed() :
	if GLGameManagerBus.curr_energy <= 0:
		handle_power_ran_out._power_ran_out(true)
		power_out = true
	else :
		handle_power_ran_out._power_ran_out(false)	
		power_out = false 
	

func _toggle_alert_symbol(stat_type :String, toggleValue : bool, symbol_type : String) :
	if stat_type == 'strength' :
		match symbol_type :
			'caution' :
				strength_caution_active = toggleValue
			'warning' :
				strength_warning_active = toggleValue
		# update energy spent
		energy_spent_updater._handle_alert_symbol(
			'strength',
			convert_alert_symbol.convert(strength_caution_active, strength_warning_active)
		)
		
	if stat_type == 'intelligence' :
		match symbol_type :
			'caution' :
				intelligence_caution_active = toggleValue
			'warning' :
				intelligence_warning_active = toggleValue
		# update energy spent
		energy_spent_updater._handle_alert_symbol(
			'intelligence',
			convert_alert_symbol.convert(intelligence_caution_active, intelligence_warning_active )
		)
		
	if stat_type == 'community' :
		match symbol_type :
			'caution' :
				community_caution_active = toggleValue
			'warning' :
				community_warning_active = toggleValue
		# update energy spent
		energy_spent_updater._handle_alert_symbol(
			'community',
			convert_alert_symbol.convert(community_caution_active, community_warning_active)
		)
	
func _update_clean_stat_value(type : String, new_value : float) :

	if power_out :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	# prevent changing value if quanity not selected
	if prisoner_quantity == 0 :
		handle_prisoner_quanity_not_selected._player_tried_incrementing_stat()
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
	
	match type :
		'strength' :
			clean_strength = new_value
		'intelligence' :
			clean_intelligence = new_value
		'community' :
			clean_community = new_value

	# update energy spent
	energy_spent_updater._handle_clean_stat_value_change(type, new_value)

func _toggle_stat_disabled(type : String, toggleValue : bool) :
	
	if power_out : 	
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
	
	var original_value = 0.0
	var original_stat_cap : String = 'none'

	
	match type :
		'strength' :
			strength_disabled = toggleValue
			original_value = clean_strength
			original_stat_cap = convert_alert_symbol.convert(strength_caution_active, strength_warning_active)
		'intelligence' :
			intelligence_disabled = toggleValue
			original_value = clean_intelligence
			original_stat_cap = convert_alert_symbol.convert(intelligence_caution_active, intelligence_warning_active )
		'community' :
			community_disabled = toggleValue
			original_value = clean_community
			original_stat_cap = convert_alert_symbol.convert(community_caution_active, community_warning_active)
			
	# update energy spent 
	energy_spent_updater._handle_toggle_clean_stat_disabled(type,toggleValue,original_value, original_stat_cap)
	# update hidden stat screen
	screen_hidden_stat_quanity._profiler_changed_hidden_stat()
	
	
func _update_prisoner_quanity(quantity: int) :
	
	GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
	
	prisoner_quantity = quantity
	prisoner_quanitity_updater._prisoner_quanity_btn_selected(quantity)
	
	# update energy spent
	energy_spent_updater._handle_prisoner_quanity(quantity)
	# update hidden stat screen
	screen_hidden_stat_quanity._profiler_changed_hidden_stat()
	

func _create_prisoners() -> void:
	
	## if powers out dont do anything	
	if power_out : 
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	
	# prevent changing value if quanity not selected
	if prisoner_quantity == 0 :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		handle_prisoner_quanity_not_selected._player_tried_incrementing_stat()
		return
	
	
	## validate if theres enough energy to do this
	var can_create = energy_spent_updater._validate_create_prisoner_batch()
	if not can_create :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		GLPrisonerProfilerComponentsBus.emit_signal('player_tried_creating_with_invalid_energy')	
		return
	
	GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')

	var strength_stat_constructor = StatConstructor.new(
		"strength",
		clean_strength,
		convert_alert_symbol.convert(strength_caution_active, strength_warning_active),
		!strength_disabled
	)
	var intelligence_stat_constructor = StatConstructor.new(
		"intelligence",
		clean_intelligence,
		convert_alert_symbol.convert(intelligence_caution_active, intelligence_warning_active),
		!intelligence_disabled
	)
	var community_stat_constructor = StatConstructor.new(
		"community",
		clean_community,
		convert_alert_symbol.convert(community_caution_active , community_warning_active),
		!community_disabled
	)
	var prisoner_cell_constructor : CellConstructor = CellConstructor.new(
		prisoner_quantity,
		0, # hidden_stat_quantity TODO
		strength_stat_constructor,
		intelligence_stat_constructor,
		community_stat_constructor
	)
	
	reset_componnets._reset()
	handle_prisoners_just_created._prisoners_just_created()
	
	GLCellCreatorBus.emit_signal(
		"create_prisoner_cells",
		prisoner_cell_constructor
	)
	
	
