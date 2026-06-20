extends Node2D

# components 
@onready var detect_area : Area2D = $DetectArea

var found_overlap : bool = false


func _detect_overlap() -> bool:
	
	# turn on monitoring
	detect_area.monitoring = true
	
	await get_tree().create_timer(0.2).timeout
	
	return !found_overlap 


func _on_detect_area_area_entered(_area: Area2D) -> void:
	found_overlap = true


func _on_detect_area_body_entered(_body: Node2D) -> void:
	found_overlap = true
