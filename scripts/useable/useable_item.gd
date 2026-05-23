extends Node

var designated_useable_item_obj : UseableItemObject

# components
@onready var useable_item_sprite : Sprite3D = $UseableItemSprite
@onready var item_label : Label3D = $ItemLabel
@onready var energy_left_label : Label3D = $EnergyLeft

# textures
@onready var defect_shot_png : Texture = preload("res://models/usable_items/serum_items/defect_shot.png")
@onready var hidden_shot_png : Texture = preload("res://models/usable_items/serum_items/hidden_shot_item.png")
@onready var steroid_png : Texture = preload("res://models/usable_items/steriod/steriod.png")

func load_item(include_energy : bool, specified_energy_left = 0) -> void:
	load_item_sprite()
	load_item_label()
	load_item_name()
	
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
