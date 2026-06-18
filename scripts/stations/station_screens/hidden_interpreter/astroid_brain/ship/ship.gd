extends CharacterBody2D

@export var move_speed : float = 200.0

# components
@onready var bullet_scene : PackedScene = preload("res://scenes/stations/station_screens/hidden_interpreter/astroid_brain/ship/bullet.tscn")
@onready var bullet_spawn_point: Node2D = $BulletSpawnPoint
@onready var bullets_parent_node : Node = $Bullets


func _process(delta: float) -> void:
	
	handle_movement()
	
	if Input.is_action_just_pressed('jump') :
		handle_create_bullet()			
	


func handle_movement() :
	var move_dir = Input.get_axis('left', 'right')
	
	if Input.is_action_pressed('left') :	
		velocity.x = move_dir * move_speed 
	
	elif Input.is_action_pressed('right') :
		velocity.x = move_dir * move_speed 
	
	else : 
		velocity = lerp(velocity, Vector2.ZERO, 0.2)
	
	move_and_slide()


func handle_create_bullet() -> void:
	var bullet_instance: CharacterBody2D = bullet_scene.instantiate()
	
	bullet_instance.global_position = bullet_spawn_point.global_position
	bullet_instance.global_rotation = bullet_spawn_point.global_rotation
	
	bullets_parent_node.add_child(bullet_instance)
	
	
