extends Node

@onready var switch_screen: Node = $SwitchScreen
@onready var energy_left_label: Label = $EnergyLeft/EnergyLeft

# Change this path/type if this is actually a Sprite2D or TextureRect.
@onready var energy_sprite: CanvasItem = $EnergyLeft/EnergyLeft

@onready var station_parent: Node3D = $"../../../.."

var energy_left: int = 0
var max_energy: int = 0

var last_total_energy: int = 0


func _ready() -> void:
	GLGameManagerBus.connect("energy_changed", _handle_energy_changed)
	GLGameManagerBus.connect("proceed_next_energy_turn", _handle_energy_changed)


func _load_inital_energy_left(inital_energy: int) -> void:
	max_energy = inital_energy
	energy_left = inital_energy
	
	last_total_energy = GLGameManagerBus.curr_energy
	
	load_label_text()


func reset_label() -> void:
	energy_left = 0
	max_energy = 0
	last_total_energy = GLGameManagerBus.curr_energy
	
	energy_left_label.text = "0"
	energy_left_label.add_theme_color_override("font_color", Color.WHITE)
	energy_sprite.modulate = Color.WHITE


func _handle_energy_changed() -> void:
	
	
	# very hacky await here for the energy to change
	# this is only important for the prisoner_creatioon method of changing energy
	await get_tree().create_timer(1.0).timeout
	
	# Make sure an offer is active.
	if not station_parent.selected_offer_demand_constructor:
		return
	
	var current_total_energy: int = GLGameManagerBus.curr_energy
	
	# How much energy was lost since last update.
	var energy_difference: int = max(0, last_total_energy - current_total_energy)
	
	last_total_energy = current_total_energy
	
	energy_left -= energy_difference
	
	
	energy_left = max(energy_left, 0)
	
	load_label_text()
	
	if energy_left <= 0:
		station_parent._handle_offer_energy_exspired()


func load_label_text() -> void:
	if max_energy <= 0:
		energy_left_label.text = "0"
		energy_left_label.add_theme_color_override("font_color", Color.WHITE)
		energy_sprite.modulate = Color.WHITE
		return
	
	energy_left_label.text = str(energy_left)
	
	var percent_of_max: float = float(energy_left) / float(max_energy)
	percent_of_max = clamp(percent_of_max, 0.0, 1.0)
	
	if percent_of_max > 0.5:
		energy_left_label.add_theme_color_override("font_color", Color.WHITE)
		energy_sprite.modulate = Color.WHITE
	
	elif percent_of_max > 0.25:
		energy_left_label.add_theme_color_override("font_color", Color.ORANGE)
		energy_sprite.modulate = Color.ORANGE
	
	else:
		energy_left_label.add_theme_color_override("font_color", Color.RED)
		energy_sprite.modulate = Color.RED
