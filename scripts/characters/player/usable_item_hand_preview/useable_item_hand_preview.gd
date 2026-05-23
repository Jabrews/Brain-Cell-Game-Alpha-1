extends Node


# components
@onready var hand_preview_sprite : Sprite3D = $HandPreviewSprite
# textures
@onready var defect_shot_png : Texture = preload("res://models/usable_items/serum_items/defect_shot.png")
@onready var hidden_shot_png : Texture = preload("res://models/usable_items/serum_items/hidden_shot_item.png")
@onready var steroid_png : Texture = preload("res://models/usable_items/steriod/steriod.png")

func _ready() -> void:
	GLUsableItemBus.connect('useable_item_picked_up', _handle_useable_item_picked_up)
	GLUsableItemBus.connect('useable_item_dropped', _handle_useable_item_dropped)
	GLUsableItemBus.connect('useable_item_used', _handle_item_used)


func _handle_useable_item_picked_up(useable_item_obj : UseableItemObject) :
	match useable_item_obj.item_type :	
		'defect_shot' :		
			hand_preview_sprite.texture = defect_shot_png
		'hidden_shot' :
			hand_preview_sprite.texture = hidden_shot_png
		'steroid' :
			hand_preview_sprite.texture = steroid_png 
		_ : 
			push_error('non valid item type for hand display found')
	
	hand_preview_sprite.visible = true

func _handle_useable_item_dropped(_useable_item_obj : UseableItemObject) :
	hand_preview_sprite.visible = false

func _handle_item_used(item_used_up : bool, _useable_item_obj : UseableItemObject) : 
	if item_used_up :
		hand_preview_sprite.visible = false
