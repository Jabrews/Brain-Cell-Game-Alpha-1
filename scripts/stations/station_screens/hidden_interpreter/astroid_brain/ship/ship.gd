extends CharacterBody2D

var can_shoot : bool = false 
var can_move : bool = false

var starting_pos : Vector2

# components
@onready var bullet_scene : PackedScene = preload("res://scenes/stations/station_screens/hidden_interpreter/astroid_brain/ship/bullet.tscn")
@onready var bullet_spawn_point: Node2D = $BulletSpawnPoint
@onready var bullets_parent_node : Node = $Bullets
@onready var shoot_delay_timer : Timer = $ShootDelay
# helpers
@onready var handle_ship_duplicates : Node = $HandleShipDuplicates


	
func _ready() -> void:
	shoot_delay_timer.wait_time = IVAstroidBrain.shooting_delay_wait_time
	shoot_delay_timer.connect('timeout', _handle_shoot_delay_timeout)
	
	starting_pos = global_position
	
	

func _process(_delta: float) -> void:
	
	if can_move :	
		handle_movement()
	
	if Input.is_action_just_pressed('jump') and can_shoot:
		shoot()
	

func shoot() :
	handle_create_bullet()
	can_shoot = false
	
	shoot_delay_timer.wait_time = IVAstroidBrain.shooting_delay_wait_time
	shoot_delay_timer.start()	
	
	handle_ship_duplicates._shoot()

func _handle_shoot_delay_timeout() :
	can_shoot = true

func handle_movement() :
	var move_dir = Input.get_axis('left', 'right')
	
	var move_speed = IVAstroidBrain.move_speed
	
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

func _handle_ship_hit() :
	GLInterpreterGames.emit_signal('parent_ship_died')
	
	
func toggle_start(toggle_value : bool) :
	if toggle_value :
		can_move = true
		can_shoot = true
	else : 
		can_move = false
		shoot_delay_timer.stop()
		can_shoot = false
		handle_ship_duplicates.delete_all_ships()		
		global_position = starting_pos
		
		
		
	
	
	
#
