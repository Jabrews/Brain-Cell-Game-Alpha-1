extends Node

# components
@export var useable_item_manager : Node3D

func find_case():
	
	var players_useable_item = useable_item_manager.players_useable_items 
