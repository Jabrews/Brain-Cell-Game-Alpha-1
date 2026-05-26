extends Node

var interact_ray_active : bool = false
var usable_item_ray_active : bool = false

# componnets 
@onready var interact_ray : RayCast3D = $InteractRay
@onready var usable_item_ray : RayCast3D = $UseableItemRay
@onready var stat_display_ray : RayCast3D = $StatDisplayRay
@onready var hover_effect_ray : RayCast3D = $HoverEffectRay
@onready var axe_interact_ray : RayCast3D = $AxeInteractRay

func _ready() -> void: 
	GLPlayerState.connect('toggle_player_picked_up_axe_mount', _handle_toggle_player_picked_up_axe_mount)


func set_ray_mode(mode: String) -> void:
	
	match mode:
		"interact":
			interact_ray_active = true
			usable_item_ray_active = false
		
		"useable":
			interact_ray_active = false
			usable_item_ray_active = true
		
		"none":
			interact_ray_active = true 
			usable_item_ray_active = true 
		
		_:
			push_error("invalid ray mode: " + mode)
	
	update_rays()

func update_rays() -> void:
	interact_ray.enabled = interact_ray_active
	usable_item_ray.enabled = usable_item_ray_active
	
func _handle_toggle_player_picked_up_axe_mount(toggle_value) :
	
	# holding axe therfore disable all
	if toggle_value :	
		interact_ray.enabled = false
		usable_item_ray.enabled = false
		stat_display_ray.enabled = false
		#hover_effect_ray.enabled = false
		interact_ray_active = false
		usable_item_ray_active = false
	# else enable it back all on
	else :
		interact_ray.enabled = true 
		usable_item_ray.enabled = true 
		stat_display_ray.enabled = true 
		#hover_effect_ray.enabled = true 
		interact_ray_active = true
		usable_item_ray_active = true 
	
	
	
