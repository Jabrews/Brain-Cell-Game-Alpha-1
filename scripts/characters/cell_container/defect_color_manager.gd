extends Node

@onready var container_mesh : MeshInstance3D = $"../MeshInstance3D"

func update_defect_color_manager(designated_brain_cell : BrainCell) -> void:
	
	var highest_defect_stat = get_highest_defect_stat(designated_brain_cell)
	var max_defect_value = IVCellCreator.max_stat_value
	
	# convert defect into percent
	var defect_percent = highest_defect_stat / max_defect_value
	
	var color : Color

# 	split into fourths
	if defect_percent <= 0.25:
		color = Color(0.8, 0.1, 0.1) # dark red
			
	elif defect_percent <= 0.50:
		color = Color(0.65, 0.06, 0.06) # darker crimson
			
	elif defect_percent <= 0.75:
		color = Color(0.52, 0.03, 0.03) # deep dried blood
			
	else:
		color = Color(0.4, 0.0, 0.0) # very dark blood red
			
	# apply transparency
	var material = container_mesh.get_active_material(0)
	
	if material is StandardMaterial3D:
		material = material.duplicate()
		container_mesh.set_surface_override_material(0, material)
		
		material.albedo_color = color
	
	
func get_highest_defect_stat(designated_brain_cell) :	
	
	var cell_defect_stats = {
		'strength' : designated_brain_cell.strength_defect,
		'intelligence' : designated_brain_cell.intelligence_defect,
		'community' : designated_brain_cell.community_defect,
	}
	
	
	# get highest defect from either stat	
	var highest_value : float = 0.0

	for defect_value in cell_defect_stats.values():
		if defect_value > highest_value:
			highest_value = defect_value
	
	return highest_value


	
