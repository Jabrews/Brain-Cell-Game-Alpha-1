extends Node

@export var stat_type : String

## logic components
@onready var helper_increment_clean_range : Node = $HelperIncrementCleanRange
@onready var helper_addition_energy_value : Node = $HelperAdditionEnergyValue

## screen componnet
@onready var screen_cap_control : Node2D = $RangeControl/CapControlTv/SubViewport/CapControll

## parent componnetd
@onready var prisoner_profiler_parent : Node3D = $"../.."

## visual components
# main range tect
@onready var clean_stat_range_label : Label3D = $RangeControl/CurrStatDisplayLabelsl/CleanRange/CleanStatRange
@onready var clean_stat_addition_label : Label3D = $RangeControl/CurrStatDisplayLabelsl/Addition/CleanStatAdditon
@onready var energy_icon : Sprite3D = $RangeControl/CurrStatDisplayLabelsl/Addition/EnergyIcon3
# on off btn stuff
@onready var off_stat_label : Label3D = $RangeControl/CurrStatDisplayLabelsl/OffLabel
# the label on the btn itself
@onready var on_off_label : Label3D = $OnOffBtn/OnOffLabel
@onready var on_off_btn_mesh : MeshInstance3D = $OnOffBtn/MeshInstance3D

# stat type label
@onready var stat_type_label : Label3D =$StatTypeLabel

var blue_material : StandardMaterial3D
var red_material : StandardMaterial3D

var stat_on : bool = true
var current_stat_value : float = 0.0

func _ready():
	blue_material = StandardMaterial3D.new()
	blue_material.albedo_color = Color.BLUE

	red_material = StandardMaterial3D.new()
	red_material.albedo_color = Color.RED

	on_off_btn_mesh.material_override = blue_material
	
	stat_type_label.text = stat_type


func _handle_toggle_on_off(toggleValue : bool) :
	stat_on = toggleValue
	
	match stat_on:
		true:
			on_off_label.text = "on"
			clean_stat_range_label.visible = true
			clean_stat_addition_label.visible = true
			off_stat_label.visible = false
			energy_icon.visible = true

			on_off_btn_mesh.material_override = blue_material
			
			screen_cap_control._toggle_display_off_screen(false)
			prisoner_profiler_parent._toggle_stat_disabled(stat_type, false)

		false:
			on_off_label.text = "off"
			clean_stat_range_label.visible = false
			clean_stat_addition_label.visible = false
			off_stat_label.visible = true
			energy_icon.visible = false

			on_off_btn_mesh.material_override = red_material
			
			screen_cap_control._toggle_display_off_screen(true)
			prisoner_profiler_parent._toggle_stat_disabled(stat_type, true)
			
func _handle_stat_increment_btn(increment_direction : String) :
	
	if not stat_on :
		return
	
	# we count 5 points in each range
	var increment = IVCellCreator.max_stat_value / 20.0
	
	# handle change value
	if increment_direction == 'up' :
		
		# prevent up once we hit top
		if current_stat_value >= IVCellCreator.max_stat_value :
			return
		
		current_stat_value += increment
	elif increment_direction == 'down' :
		
		# prevent up once we hit bottom
		if current_stat_value <= 0:
			return
			
		current_stat_value -= increment
	

		
	# update clean range label (EX. mid-low)prisoner_profiler_parent
	var new_clean_range = helper_increment_clean_range._handle_get_clean_range(current_stat_value)
	clean_stat_range_label.text = new_clean_range
	
	# update energy range label (EX. +20)
	var new_addition = helper_addition_energy_value._handle_get_energy_add_value(increment_direction)
	clean_stat_addition_label.text = '- ' + str(new_addition)
	
	# tell screen about new value and update symbols
	screen_cap_control.update_current_stat_value(current_stat_value, new_clean_range)
	update_target_stat()
	
	# tell parent about new value
	prisoner_profiler_parent._update_clean_stat_value(stat_type, current_stat_value)
	

func update_target_stat() :
	var target_cell = GLCellManagerBus.target_cell_refrence
	
	var target_stat_value : float = 0.0
	
	match stat_type :
		'strength' :
			target_stat_value = target_cell.strength.value
		'intelligence' :
			target_stat_value = target_cell.intelligence.value
		'community' :
			target_stat_value = target_cell.community.value
	
	screen_cap_control.update_target_stat(target_stat_value)
	

func _toggle_alert_symbol(toggleValue : bool , symbol_type : String) :
	prisoner_profiler_parent._toggle_alert_symbol(stat_type, toggleValue, symbol_type)
