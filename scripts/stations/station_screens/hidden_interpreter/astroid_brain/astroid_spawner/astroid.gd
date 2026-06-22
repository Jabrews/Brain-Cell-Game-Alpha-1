extends CharacterBody2D 


var x_move_direction = 0

var horizontal_speed = 0
var vertical_speed = 0

@export var health = 3
var max_health : int = 0

@export var points = 3

@export var can_break_into_smaller : bool = false

var extra_astroid_no_points_extra : bool 




# components 
@onready var spawn_ghost_delay : Timer = $SpawnGhostDelay
@onready var astroid_ghost_sprite_scene : PackedScene = preload("res://scenes/stations/station_screens/hidden_interpreter/astroid_brain/astroid/astroid_ghost_sprite.tscn")
@onready var astroid_health_label : Label = $AstroidHealth
@onready var sprite : Sprite2D = $Sprite
#@onready var can_hit_delay_timer : Timer = $CanHitDelay
# helpers 
@onready var spawn_smaller_breaking_astroids : Node = $SpawnSmallerBreakingAstroids
@onready var handle_astroid_hit_ground : Node = $HandleAstroidHitGround


func _ready() -> void:
	
	
	sprite.material = sprite.material.duplicate()
	
	pick_starting_direction()	
	pick_starting_scale()
	pick_speed()
	pick_outline()
		
	
	spawn_ghost_delay.connect('timeout', _spawn_ghost_timeout)
	spawn_ghost_delay.start()
	
	max_health = health

	# update health label
	astroid_health_label.text = str(health)
	
	
	
func _process(_delta: float) -> void:
	
	
	# move to the move direction	
	velocity.x = x_move_direction * horizontal_speed
	velocity.y = 1 * vertical_speed
		
	move_and_slide()
	
func pick_starting_scale() :
	if health <= 2 :
		scale = Vector2(0.5, 0.5)
	elif health > 2 and health <= 4 :
		scale = Vector2(0.7, 0.7)
	else :
		scale = Vector2(1.0, 1.0)

	
func pick_starting_direction() :
	var random_num = randi_range(0, 100)
	if random_num >= 50 : 
		x_move_direction = 1
	else : 
		x_move_direction = -1

func pick_outline() :
	if points == 0 :
		sprite.material.set_shader_parameter('border_color', Color.TRANSPARENT)
	elif points > 0 and points <= 2 :
		sprite.material.set_shader_parameter('border_color', Color.WHITE)
	elif points > 2 and points <= 4 :
		sprite.material.set_shader_parameter('border_color', Color.YELLOW)
		astroid_health_label.add_theme_color_override("font_color", Color.YELLOW)	
	else :
		sprite.material.set_shader_parameter('border_color', Color.RED)
		astroid_health_label.add_theme_color_override("font_color", Color.RED)	


func pick_speed() :
	if health <= 2 :
		vertical_speed = IVAstroidBrain.small_astroid_speed
		horizontal_speed = IVAstroidBrain.small_astroid_speed
	elif health > 2 and health <= 4 :
		vertical_speed = IVAstroidBrain.medium_astroid_speed
		horizontal_speed = IVAstroidBrain.medium_astroid_speed
	else :
		vertical_speed = IVAstroidBrain.large_astroid_speed
		horizontal_speed = IVAstroidBrain.large_astroid_speed
		

func _spawn_ghost_timeout() :
	var astroid_ghost_sprite_instance : Sprite2D = astroid_ghost_sprite_scene.instantiate()	
	astroid_ghost_sprite_instance._load(global_position, scale)
	get_parent().add_child(astroid_ghost_sprite_instance)

func _handle_hit_by_bullet() :
	
	
	health -= 1 	
	astroid_health_label.text = str(health)
	
	if health == 0 :
		
		if can_break_into_smaller :
			spawn_smaller_breaking_astroids._spawn(max_health, global_position)
			
		GLInterpreterGames.emit_signal('ship_collected_point', points)
		
		if not extra_astroid_no_points_extra :	
			GLInterpreterGames.emit_signal('astroid_killed')			
		
		queue_free()
	
		
		
func _handle_hit_ground() -> void:
	handle_astroid_hit_ground._handle(global_position, max_health)
	
	if not extra_astroid_no_points_extra :	
		GLInterpreterGames.emit_signal('astroid_killed')			
		
	queue_free()
