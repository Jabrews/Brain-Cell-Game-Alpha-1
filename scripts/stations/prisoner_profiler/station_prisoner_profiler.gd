extends Node

var selected_stat : String = ''

var strength_value : int = 0
var intelligence_value : int = 0
var community_value : int = 0

var strength_enabled : bool = true
var intelligence_enabled : bool = true
var community_enabled : bool = true

var strength_lock_starting_value : int = 0
var intelligence_lock_starting_value : int = 0
var community_lock_starting_value : int = 0
var inaccessible_starting_value : int = 0


# componnets
@onready var screen_large_stat_displays : Array[Node2D] = [
	$StatDisplay/StatPanels/StrengthStatPanel/CapControlTv/SubViewport/LargeStatDisplay,
	$StatDisplay/StatPanels/IntelligenceStatPanel/CapControlTv/SubViewport/LargeStatDisplay,
	$StatDisplay/StatPanels/CommunityStatPanel/CapControlTv/SubViewport/LargeStatDisplay
]
@onready var screen_small_stat_display : Node2D = $ControlInterface/SmallStatDisplay/TvFrontPanel/SubViewport/SmallStatDisplay
@onready var on_off_btn : StaticBody3D = $ControlInterface/Control/OnOffBtn

# helper
@onready var handle_symbols : Node = $Logic/HandleSymbols


func _ready() -> void:
	GLGameManagerBus.connect('proceed_next_energy_turn', _handle_next_turn)
	
	# quick delay on startup for cell creation logic 
	await get_tree().create_timer(1.0).timeout
	handle_symbols._generate_inaccessible()
	handle_symbols._generate_locks()
	

func update_selected_stat(stat_type : String) :
	selected_stat = stat_type
	screen_small_stat_display._update_stat(stat_type, stat_type_to_value(stat_type), stat_type_to_enabled(stat_type))
	on_off_btn.update_toggle_off_btn()

func _handle_stat_value_changed(stat_type : String, new_value : int) :
	
	
	# prevent disabled stats from incrementing
	if stat_type_to_enabled(stat_type) == false :
		return
	
	if new_value <= 0 :
		new_value = 0
	
	if new_value >= inaccessible_starting_value :	
		new_value = inaccessible_starting_value
	
	match stat_type :
		'strength' : 
			if new_value >= strength_lock_starting_value :
				new_value = strength_lock_starting_value
		'intelligence' : 
			if new_value >= community_lock_starting_value:
				new_value = community_lock_starting_value
		'community' : 
			if new_value >= intelligence_lock_starting_value:
				new_value = intelligence_lock_starting_value
	
	
	
	
	match stat_type : 
		'strength' :
			strength_value = new_value
		'intelligence' :
			intelligence_value = new_value
		'community' :
			community_value = new_value
		
	update_display_screens(stat_type)

func _handle_toggle_stat_enabled() :
	
	# cant toggle when no stat selected
	if selected_stat == '':	
		return
	
	match selected_stat:
		'strength' :
			strength_enabled = !strength_enabled
		'intelligence' :
			intelligence_enabled = !intelligence_enabled
		'community' :
			community_enabled = !community_enabled
	
	update_display_screens(selected_stat)



func update_display_screens(stat_type : String) :
	match stat_type : 
		'strength' :
			screen_large_stat_displays[0]._update_stat(strength_value, strength_enabled)
			screen_small_stat_display._update_stat(stat_type, strength_value, strength_enabled)
		'intelligence' :
			screen_large_stat_displays[1]._update_stat(intelligence_value, intelligence_enabled)
			screen_small_stat_display._update_stat(stat_type, intelligence_value, intelligence_enabled)
		'community' :
			screen_large_stat_displays[2]._update_stat(community_value, community_enabled)
			screen_small_stat_display._update_stat(stat_type , community_value, community_enabled)
	
	

func stat_type_to_value(stat_type : String)  -> float :
	match stat_type : 
		'strength' :
			return strength_value
		'intelligence' :
			return intelligence_value
		'community' :
			return community_value
		_ :
			return 0.0

func stat_type_to_enabled(stat_type : String)  -> bool:
	match stat_type : 
		'strength' :
			return strength_enabled
		'intelligence' :
			return intelligence_enabled 
		'community' :
			return community_enabled 
		_ :
			return 0.0

func _handle_next_turn() : 
	strength_value = 0
	strength_enabled = true
	intelligence_value = 0
	intelligence_enabled = true
	community_value = 0
	community_enabled = true
	selected_stat = ''
	screen_large_stat_displays[0]._update_stat(strength_value, strength_enabled)
	screen_large_stat_displays[1]._update_stat(intelligence_value, intelligence_enabled)
	screen_large_stat_displays[2]._update_stat(community_value, community_enabled)
	handle_symbols._generate_locks()

func _handle_next_round() :
	handle_symbols._generate_inaccessible()
