extends Node

# components
@onready var parent_profiler : Node3D = $"../.."

@onready var active_strength_mesh : MeshInstance3D = $"../../StatDisplay/StatPanels/ActiveMeshes/StrengthActive"
@onready var active_intelligence_mesh : MeshInstance3D = $"../../StatDisplay/StatPanels/ActiveMeshes/IntelligenceActive"
@onready var active_community_mesh : MeshInstance3D = $"../../StatDisplay/StatPanels/ActiveMeshes/CommunityActive"

var stats : Array[String] = [
	"community",
	"intelligence",
	"strength",
]

func _stat_cycle_btn_down(direction : String) -> void:
	var index_direction : int = 0
	
	match direction:
		"up":
			index_direction = 1
		"down":
			index_direction = -1
		_:
			push_error("Invalid direction: " + direction)
			return
	
	var current_selected_stat : String = parent_profiler.selected_stat
	var current_index : int = -1
	
	if current_selected_stat != "":
		current_index = selected_stat_to_index(current_selected_stat)
	
	current_index += index_direction
	
	if current_index >= 0 and current_index < stats.size():
		parent_profiler.update_selected_stat(stats[current_index])
	else:
		parent_profiler.update_selected_stat('')
	
	update_active_mesh()


func selected_stat_to_index(current_selected_stat : String) -> int:
	var index : int = stats.find(current_selected_stat)
	
	if index == -1:
		push_error("No stat index found corresponding with: " + current_selected_stat)
	
	return index


func update_active_mesh() -> void:
	reset_active_mesh()
	
	var selected_stat : String = parent_profiler.selected_stat
	
	match selected_stat:
		"strength":
			active_strength_mesh.visible = true
		"intelligence":
			active_intelligence_mesh.visible = true
		"community":
			active_community_mesh.visible = true
		"":
			pass
		_:
			push_error("Invalid selected_stat: " + selected_stat)


func reset_active_mesh() -> void:
	active_strength_mesh.visible = false
	active_intelligence_mesh.visible = false
	active_community_mesh.visible = false
