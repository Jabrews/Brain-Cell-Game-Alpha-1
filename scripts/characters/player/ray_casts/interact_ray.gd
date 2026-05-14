extends RayCast3D 

# interactable pickup
var player_holding_item : bool = false
var held_item 

# components
@onready var ray_cast_controller_parent : Node3D = $".."

func _process(_delta):

	if not Input.is_action_just_pressed('interact'):
		return
	
	var collider = get_collider()
	
	# --- DROP LOGIC ---
	if player_holding_item:
		if held_item:
			held_item._on_pickup_interacted(null)
			player_holding_item = false
			held_item = null
			ray_cast_controller_parent.set_ray_mode('none')
			
		# if cell container play sound 
		if collider.get_parent() : 
			if collider.get_parent().is_in_group('brain_cell_container') :
					GLPlayerLocalSoundsBus.emit_signal('sound_cell_container_dropped')
					
		return
	
	# --- NO COLLIDER ---
	if not collider:
		return
	
	if not collider.is_in_group('interactable'):
		return
	
	# --- BUTTON ---
	if collider is InteractableBtn:
		collider.handle_btn_interacted()
		return
	
	# --- PICKUP ---
	if collider is InteractablePickup:
		collider._on_pickup_interacted(self)
		player_holding_item = true
		held_item = collider
		ray_cast_controller_parent.set_ray_mode('interact')
		
		# if cell container play sound 
		if collider.get_parent() :
			if collider.get_parent().is_in_group('brain_cell_container') :
				GLPlayerLocalSoundsBus.emit_signal('sound_cell_container_pickup')
		
		
		return
	
	# --- GENERIC ---
	if collider.has_method('_handle_interacted'):
		collider._handle_interacted()
