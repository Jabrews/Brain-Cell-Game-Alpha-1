extends CharacterBody3D

## export vars
@export var mouse_sensitivity_x := 0.006
@export var mouse_sensitivity_y := 0.004

## components
@onready var camera_pivot : Node3D = $CameraPivot
@onready var camera := $CameraPivot/Camera3D

var speed : float = 20.0

var is_paused : bool = false

var starting_postion : Vector3


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	starting_postion = global_position	
	
	# update char refrence state
	GLPlayerState.player_refrence = self
	
	GLChairBus.connect('toggle_player_sat_on_interpreter_chair', _handle_toggle_player_sat_on_interpreter_chair)	
	GLGameManagerBus.connect('reset_player_position', _handle_reset_player_position)	
	
	
	
	
	
func _physics_process(delta: float) -> void:
	
	if is_paused :
		return
	
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor() and Input.is_action_just_pressed('jump') :
		velocity.y += 10
	
	##### dir #####
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (camera_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	## movement
	if direction.length() > 0.0:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	
		# for when holding btn for instance
		if GLHoldingDisplayBus.player_is_holding == true : 	
			GLHoldingDisplayBus.emit_signal('player_interupted_hold')					
	
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	move_and_slide()
	

### BOBBLE + CAMERA ###
func _unhandled_input(event: InputEvent) -> void:
	
	if is_paused :
		return
	
	if event is InputEventMouseMotion:
		
		camera_pivot.rotate_y(-event.relative.x * mouse_sensitivity_x)
		camera.rotate_x(-event.relative.y * mouse_sensitivity_y)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(80))

func _handle_toggle_player_sat_on_interpreter_chair(toggle_value : bool, _interpreter_type : String) :
	if toggle_value :
		is_paused = true
		visible = false
	else :
		is_paused = false
		visible = true
	
func _handle_reset_player_position() :
	global_position = starting_postion
	
	
	
