extends Node

# componnets
@onready var stat_mesh : MeshInstance3D = $"../StatMesh"

func toggle_display_stat_area(toggleValue : bool, player_refrence : CharacterBody3D) : 
	stat_mesh.player = player_refrence
	stat_mesh.visible = toggleValue
	
