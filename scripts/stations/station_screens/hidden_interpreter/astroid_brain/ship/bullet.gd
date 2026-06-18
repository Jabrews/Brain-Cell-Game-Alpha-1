extends CharacterBody2D

@export var bullet_speed : float = 200
@onready var delete_timer : Timer = $DeleteTimer

func _ready() -> void:
	delete_timer.connect('timeout', _handle_delete_timeout)	


func _process(delta: float) -> void:
	
	velocity.y = bullet_speed *	-1 # up
	
	move_and_slide()
	
func _handle_delete_timeout() :
	queue_free()
		
	
	
