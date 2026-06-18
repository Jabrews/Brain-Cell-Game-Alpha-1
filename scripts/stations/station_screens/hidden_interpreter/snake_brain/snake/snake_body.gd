extends StaticBody2D

var snake_index : int = -1

# componnets
@onready var kill_player_area : Area2D = $KillPlayer

func _load(index : int) -> void:
	snake_index = index
	
	# wait a bit before 
	await get_tree().create_timer(0.2).timeout
	kill_player_area.monitoring = true


func _move_body(target_position : Coord) -> void:
	global_position = Vector2(target_position.x, target_position.y)

func _on_kill_player_body_entered(body: Node2D) -> void:
	if body.is_in_group('player') :
		GLInterpreterGames.emit_signal('snake_hit_kill_area')
