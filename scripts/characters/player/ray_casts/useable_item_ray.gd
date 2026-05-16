extends RayCast3D 

# interactable pickup
var player_holding_item : bool = false
var held_useable_item_obj : UseableItemObject

# components
@onready var ray_cast_controller_parent : Node3D = $".."


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

	if not collider.is_in_group('brain_cell_container'):
		return


	## DEFECT SHOT ###
	if held_useable_item_obj.item_type == 'defect_shot':

		GLUsableItemBus.emit_signal(
			'use_defect_shot',
			collider.designated_brain_cell,
			held_useable_item_obj
		)

		# increment shot energy downward
		held_useable_item_obj.item_energy -= 1

		GLPlayerLocalSoundsBus.emit_signal('sound_shot_used')

		if held_useable_item_obj.item_energy <= 0:

			GLUsableItemBus.emit_signal(
				'useable_item_used',
				true,
				held_useable_item_obj
			)

			handle_item_used_up(held_useable_item_obj)


		else:

			GLUsableItemBus.emit_signal(
				'useable_item_used',
				false,
				held_useable_item_obj
			)
			
			GLUseableItemManagerBus.emit_signal('useable_item_changed', held_useable_item_obj)


	## HIDDEN SHOT ###
	elif held_useable_item_obj.item_type == 'hidden_shot':

		GLPlayerLocalSoundsBus.emit_signal('sound_shot_used')

		GLUsableItemBus.emit_signal(
			'use_hidden_shot',
			collider.designated_brain_cell,
			held_useable_item_obj
		)

		GLUsableItemBus.emit_signal(
			'useable_item_used',
			true,
			held_useable_item_obj
		)

		handle_item_used_up(held_useable_item_obj)




func handle_item_used_up(useable_item : UseableItemObject) -> void:

	player_holding_item = false
	held_useable_item_obj = null

	toggle_ray_cast_manager(false)
	
	GLUseableItemManagerBus.emit_signal('useable_item_deleted', useable_item.item_id)


func toggle_ray_cast_manager(toggleValue : bool) -> void:

	if toggleValue:
		ray_cast_controller_parent.set_ray_mode('useable')

	else:
		ray_cast_controller_parent.set_ray_mode('none')
