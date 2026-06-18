extends StaticBody2D 

@export var idle_move_distance_x : float = 1.5
@export var scale_collect : Vector2 = Vector2(1.2, 1.2)

var base_position : Vector2
var base_scale : Vector2

var point_amount : int = 0

# componnets
@onready var sprite : Sprite2D = $Sprite2D
@onready var retry_timer : Timer = $RetryTimer


func _ready() -> void:
	
	retry_timer.start()	
	retry_timer.connect('timeout', _handle_retry_timeout)
	
	base_position = global_position	
	base_scale = scale
	
	var idle_tween = create_tween()
	idle_tween.set_loops()	
	idle_tween.tween_property(self, 'position:x', base_position.x + idle_move_distance_x, 0.5)
	idle_tween.tween_property(self, 'position:x', base_position.x, 0.5)
	idle_tween.tween_property(self, 'position:x', base_position.x - idle_move_distance_x, 0.5)

	load_point_color()	
	
	# quick scale up
	var scale_tween = create_tween()
	scale_tween.tween_property(self, 'scale', base_scale + Vector2(0.5,0.5), 0.3)	
	scale_tween.tween_property(self, 'scale', base_scale, 0.3)	
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body.is_in_group('player')  :
	
		
		var scale_tween = create_tween()
		scale_tween.tween_property(self, 'scale', base_scale + scale_collect, 0.2)	
		scale_tween.tween_property(self, 'scale', base_scale, 0.2)	
		
		await scale_tween.finished
	
		GLInterpreterGames.emit_signal('snake_collected_point', point_amount)
		queue_free()

func load_point_color() :
	if point_amount <= 2:	# TODO create multiple points with progression
		return
	elif point_amount <= 4:
		sprite.modulate = Color.YELLOW
	else:
		sprite.modulate = Color.RED
		
func _handle_retry_timeout() :
	GLInterpreterGames.emit_signal('snake_point_retry', point_amount)	
	queue_free()
	
	
