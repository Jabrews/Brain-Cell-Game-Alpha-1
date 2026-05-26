extends CharacterBody3D

## export vars
@export var mouse_sensitivity_x := 0.007
@export var mouse_sensitivity_y := 0.002

## components
@onready var camera_pivot : Node3D = $CameraPivot
@onready var camera := $CameraPivot/Camera3D

var speed : float = 20.0


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# update char refrence state
	GLPlayerState.player_refrence = self
	
	
	
	
func _physics_process(delta: float) -> void:
	
	
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
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	move_and_slide()
	

### BOBBLE + CAMERA ###
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		
		camera_pivot.rotate_y(-event.relative.x * mouse_sensitivity_x)
		camera.rotate_x(-event.relative.y * mouse_sensitivity_y)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func set_ray_cast_rotation() :
	pass # want to match cam pivot mouse rortation. so if they look up and down it follows
	
	
