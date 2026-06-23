extends InteractableBtn

# components
@onready var parent_station: Node3D = $"../../.."
@onready var btn_mesh: MeshInstance3D = $MeshInstance3D
@onready var on_off_label: Label3D = $OnOffLabel

var blue_material: StandardMaterial3D
var red_material: StandardMaterial3D


func _overide_ready() -> void:
	set_colors()
	update_toggle_off_btn()


func set_colors() -> void:
	blue_material = StandardMaterial3D.new()
	blue_material.albedo_color = Color.BLUE
	
	red_material = StandardMaterial3D.new()
	red_material.albedo_color = Color.RED


func _on_btn_interacted() :
	parent_station._handle_toggle_stat_enabled()
	update_toggle_off_btn()


func update_toggle_off_btn() -> void:
	var selected_stat: String = parent_station.selected_stat
	
	match selected_stat:
		"strength":
			toggle_visual(parent_station.strength_enabled)
		"intelligence":
			toggle_visual(parent_station.intelligence_enabled)
		"community":
			toggle_visual(parent_station.community_enabled)
		_:
			toggle_visual(false)


func toggle_visual(toggle_value: bool) -> void:
	if toggle_value:
		btn_mesh.material_override = blue_material
		on_off_label.text = "on"
	else:
		btn_mesh.material_override = red_material
		on_off_label.text = "off"
