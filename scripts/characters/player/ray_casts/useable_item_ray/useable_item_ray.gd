extends RayCast3D 

# interactable pickup
var player_holding_item : bool = false
var held_useable_item_obj : UseableItemObject

# components
@onready var ray_cast_controller_parent : Node3D = $".."
# helpers
@onready var use_defect_shot : Node = $UseDefectShot
@onready var use_hidden_shot : Node = $UseHiddenShot
@onready var use_steroid : Node = $UseSteroid
@onready var use_ice_cube : Node = $UseIceCube


func _process(_delta):

	var collider = get_collider()

	# DROP USABLE ITEM #
	if player_holding_item and Input.is_action_just_pressed('drop_item'):
		drop_usable_item()
		return

	
	if not collider:
		return


	# PICK UP USABLE ITEM #
	if not player_holding_item:
		if collider.is_in_group('usable_item'):
			if Input.is_action_just_pressed('interact'):
				pickup_usable_item(collider)
		
		return


	# USE USABLE ITEM #
	if Input.is_action_just_pressed('interact'):
		handle_item_use(collider)


func pickup_usable_item(collider : Node) -> void:

	GLUsableItemBus.emit_signal(
		'useable_item_picked_up', 
		collider.designated_useable_item_obj
	)

	player_holding_item = true
	held_useable_item_obj = collider.designated_useable_item_obj

	collider.queue_free()

	# raycast manager
	toggle_ray_cast_manager(true)

	GLPlayerLocalSoundsBus.emit_signal('sound_item_pickup')


func drop_usable_item() -> void:

	GLUsableItemBus.emit_signal(
		'useable_item_dropped', 
		held_useable_item_obj
	)

	held_useable_item_obj = null
	player_holding_item = false

	# raycast manager
	toggle_ray_cast_manager(false)

	GLPlayerLocalSoundsBus.emit_signal('sound_item_dropped')


func handle_item_use(collider) -> void:

	if not collider.is_in_group("brain_cell_container") \
	and not collider.is_in_group("prisoner"):
		return


	## DEFECT SHOT ###
	
	if held_useable_item_obj.item_type == 'defect_shot':

		var item_used_up = use_defect_shot.use(collider, held_useable_item_obj)
		if item_used_up :
			handle_item_used_up(held_useable_item_obj)


	## HIDDEN SHOT ###
	elif held_useable_item_obj.item_type == 'hidden_shot':
		
		use_hidden_shot.use(collider, held_useable_item_obj)
		handle_item_used_up(held_useable_item_obj)
	
	## STERIOD ###
	elif held_useable_item_obj.item_type == 'steroid' :
		
		use_steroid.use(collider, held_useable_item_obj)
		handle_item_used_up(held_useable_item_obj)
	
	
	## ICE CUBE ##
	elif held_useable_item_obj.item_type == 'ice_cube' :
		
		# not used on prisoner
		if collider.is_in_group("prisoner"):
			return
		
		use_ice_cube.use(collider, held_useable_item_obj)
		
		
		handle_item_used_up(held_useable_item_obj)

func handle_item_used_up(useable_item : UseableItemObject) -> void:

	player_holding_item = false
	held_useable_item_obj = null

	toggle_ray_cast_manager(false)


func toggle_ray_cast_manager(toggleValue : bool) -> void:

	if toggleValue:
		ray_cast_controller_parent.set_ray_mode('useable')

	else:
		ray_cast_controller_parent.set_ray_mode('none')
