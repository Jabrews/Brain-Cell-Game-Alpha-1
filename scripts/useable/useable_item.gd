extends Node

var designated_useable_item_obj : UseableItemObject

# components
@onready var useable_item_sprite : Sprite3D = $UseableItemSprite
@onready var item_label : Label3D = $ItemLabel
@onready var energy_left_label : Label3D = $EnergyLeft
@onready var useable_item_display : Node3D = $UseableItemDisplay


# textures
@onready var defect_shot_png : Texture = preload("res://models/usable_items/serum_items/defect_shot.png")
@onready var hidden_shot_png : Texture = preload("res://models/usable_items/serum_items/hidden_shot_item.png")
@onready var steroid_png : Texture = preload("res://models/usable_items/steriod/steriod.png")
@onready var ice_cube_png : Texture = preload("res://models/usable_items/ice_cube/ice_cube.png")
@onready var scissors_png : Texture = preload("res://models/usable_items/scissors/scissors.png")

func load_item(include_energy : bool, specified_energy_left = 0) -> void:
	load_item_sprite()
	load_item_label()
	load_item_name()
	load_item_tip_text()
	
	if include_energy:
		load_item_energy()
	if not include_energy :
		energy_left_label.text = str(specified_energy_left)
		if designated_useable_item_obj.item_has_energy == false :
			energy_left_label.queue_free()

func load_item_label():
	match designated_useable_item_obj.item_type:
		'defect_shot':
			item_label.text = 'Defect Shot'
		'hidden_shot' :
			item_label.text = 'Hidden Shot'
		'steroid' :
			item_label.text = 'Steroid'
		'ice_cube' :
			item_label.text = 'Ice Cube'
		'scissors' :
			item_label.text = 'Scissors'

func load_item_name():
	var raw_name : String = designated_useable_item_obj.item_type
	
	var parts = raw_name.split('_')
	var final_name = ""
	
	for part in parts:
		final_name += part.capitalize() + " "
	name = final_name.strip_edges()

func load_item_sprite():
	match designated_useable_item_obj.item_type:
		'defect_shot':
			useable_item_sprite.texture = defect_shot_png
		'hidden_shot' :
			useable_item_sprite.texture = hidden_shot_png
		'steroid' :
			useable_item_sprite.texture = steroid_png 
		'ice_cube' :
			useable_item_sprite.texture = ice_cube_png
		'scissors' :
			useable_item_sprite.texture = scissors_png 

func load_item_energy():
	# if already has energy (dropped item), respect it
	if designated_useable_item_obj.item_has_energy:
		energy_left_label.text = 'energy left : ' + str(designated_useable_item_obj.item_energy)
		return
	
	# default spawn behavior
	#if designated_useable_item_obj.item_type == 'defect_shot':
		#designated_useable_item_obj.item_has_energy = true
		#designated_useable_item_obj.item_energy = 3
	
	else  :
		designated_useable_item_obj.item_has_energy = false
		designated_useable_item_obj.item_energy = 0
		energy_left_label.queue_free()
	
	#energy_left_label.text = 'energy left : ' + str(designated_useable_item_obj.item_energy)

func load_item_tip_text() :
	
	var tip_text : String = ''	
	
	match designated_useable_item_obj.item_type:
		'defect_shot':
			tip_text = 'Decreases each stat on a cell container by 15 percant, 3 charges total'

		'hidden_shot':
			tip_text = 'Reveals all hidden stats on a cell container.'

		'steroid':
			tip_text = 'Increases the clean and defect values of a cell container by 30%.'

		'ice_cube':
			tip_text = 'Freezes a cell for one turn. Frozen cells do not age, gain defects, or allow player interaction.'
		
		'scissors' :
			tip_text = 'Cut off a chosen stat from a cell.'

	useable_item_display.update_tip_label(
		tip_text	
	)
