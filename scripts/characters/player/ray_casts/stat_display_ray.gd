extends RayCast3D 

var selected_cell_stat_display : Area3D = null
@onready var player_parent : CharacterBody3D = $"../../../.."


func _process(_delta):

	if is_colliding():
		var collider = get_collider()
		
		if collider :

			if collider.is_in_group("stat_display_area"):
				selected_cell_stat_display = collider
				selected_cell_stat_display.toggle_display_stat_area(true, player_parent)
	else:
		if selected_cell_stat_display:
			selected_cell_stat_display.toggle_display_stat_area(false, null)
			selected_cell_stat_display = null
