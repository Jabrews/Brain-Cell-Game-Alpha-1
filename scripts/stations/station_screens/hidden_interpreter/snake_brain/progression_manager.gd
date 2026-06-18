extends Node

var last_tier: int = 0

func _update_progression(total_points_collected: int) -> void:
	if total_points_collected >= 10:
		_set_tier_3()
	elif total_points_collected >= 5:
		_set_tier_2()
	else:
		_set_tier_1()


func _set_tier_1() -> void:
	if last_tier == 1:
		return

	IVSnakeBrain.create_wall_delay = 4
	IVSnakeBrain.create_only_small_walls = true
	IVSnakeBrain.create_only_big_walls = false
	IVSnakeBrain.wall_loading_time_to_place = 2.0
	IVSnakeBrain.snake_speed = 90
	IVSnakeBrain.avaible_point_tiers = [1]
	IVSnakeBrain.spawn_two_walls = false
	

	last_tier = 1


func _set_tier_2() -> void:
	if last_tier == 2:
		return

	IVSnakeBrain.create_wall_delay = 3
	IVSnakeBrain.create_only_small_walls = false
	IVSnakeBrain.create_only_big_walls = false
	IVSnakeBrain.wall_loading_time_to_place = 3.5
	IVSnakeBrain.snake_speed = 100
	IVSnakeBrain.avaible_point_tiers = [1, 3]

	GLInterpreterGames.emit_signal("snake_spawn_second_point")
	IVSnakeBrain.spawn_two_walls = false

	last_tier = 2


func _set_tier_3() -> void:
	if last_tier == 3:
		return

	IVSnakeBrain.create_wall_delay = 2
	IVSnakeBrain.create_only_small_walls = false
	IVSnakeBrain.create_only_big_walls = true
	IVSnakeBrain.wall_loading_time_to_place = 5.0
	IVSnakeBrain.snake_speed = 110
	IVSnakeBrain.avaible_point_tiers = [3, 5]
	IVSnakeBrain.spawn_two_walls = true

	last_tier = 3
