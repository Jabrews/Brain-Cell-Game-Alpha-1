extends Node

# components
@onready var parent_slug : CharacterBody3D = $"../.."
@onready var worm_moving_sound : AudioStreamPlayer3D = $"../../WormMovingSound"
@onready var state_machine : Node = $".."
@onready var nav_agent : NavigationAgent3D = $"../../FloorNavAgent"
@onready var movement_delay_timer : Timer = $MovementDelayTimer

var player_refrence : CharacterBody3D


func _ready() -> void:
	movement_delay_timer.connect('timeout', _handle_movement_delay_timer_timeout)


func state_start() : 
	player_refrence = GLPlayerState.player_refrence

func state_process(_delta) : 
	
	# await getting player refrence
	if not player_refrence :
		if not movement_delay_timer.is_stopped()  :
			movement_delay_timer.stop()
			return
	
	else :
		if movement_delay_timer.is_stopped() :
			movement_delay_timer.start()
		
		
		
func _handle_movement_delay_timer_timeout() :
	worm_moving_sound.play()
	
	# two inches toward player
	inch_towards_player()
	await get_tree().create_timer(0.5).timeout
	inch_towards_player()
	
	movement_delay_timer.start()
	
	
	

		
		
func inch_towards_player() :
	
	# quick error case 
	if not player_refrence :
		return
	
	# snap target to navmesh
	var safe_target = NavigationServer3D.map_get_closest_point(
		nav_agent.get_navigation_map(),
		player_refrence.global_position
	)

	# give that to agent
	nav_agent.set_target_position(safe_target)
	
	# get NEXT path point
	var dest = nav_agent.get_next_path_position()

	# move toward that
	var local_dest = dest - parent_slug.global_position
	var direction = local_dest.normalized()
	
	# flatten vertical movement
	direction.y = 0
	direction = direction.normalized()
	
	# face direction
	var look_pos = dest
	look_pos.y = parent_slug.global_position.y
	
	if not parent_slug.global_position.is_equal_approx(look_pos):
		parent_slug.look_at(look_pos, Vector3.UP)

	# burst movement
	parent_slug.velocity = direction * 12

	# move briefly
	var move_time = 0.15
	var elapsed = 0.0

	while elapsed < move_time:
		parent_slug.move_and_slide()
		await get_tree().physics_frame
		elapsed += get_physics_process_delta_time()

	# hard stop
	parent_slug.velocity = Vector3.ZERO
		
func state_end() : 
	movement_delay_timer.stop()
	player_refrence = null
	worm_moving_sound.stop()
