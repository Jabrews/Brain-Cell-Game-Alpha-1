extends TextureRect

# components
@onready var type_image : TextureRect = $TypeImage
@onready var card_hover : TextureRect = $CardHover
@onready var flavor_text : Label = $FlavorText
@onready var shareholder_offer_manager : Node = $"../.."
# type img textures
@onready var defect_shot_png : Texture = preload("res://models/share_holder_offer_card/item_defect.png")
@onready var hidden_shot_png : Texture = preload("res://models/share_holder_offer_card/item_hidden_shot.png")
@onready var steroid_png : Texture = preload("res://models/share_holder_offer_card/item_steroid.png")
@onready var ice_cube_png : Texture = preload("res://models/share_holder_offer_card/item_ice_cube.png")
@onready var scissors_png : Texture = preload("res://models/share_holder_offer_card/item_scissors.png")

var designated_useable_item_offer : UseableOfferItem 

var starting_pos : Vector2
var up_down_tween : Tween


func _ready() -> void:

	await get_tree().process_frame

	starting_pos = position

	mouse_entered.connect(_handle_mouse_entered)
	mouse_exited.connect(_handle_mouse_exited)

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed('attack') :	
		if card_hover.visible :
			up_down_tween.kill()
			# reset position. this is important for when card re-appears, getting it in the right pos
			position = starting_pos
			shareholder_offer_manager.handle_card_picked(self)

func update(useable_item_offer : UseableOfferItem) :
	
	position = starting_pos
	modulate.a = 1.0
	
	designated_useable_item_offer = useable_item_offer 
	
	match designated_useable_item_offer.item_type:
		'defect_shot' :
			type_image.texture = defect_shot_png 
		'hidden_shot' :
			type_image.texture = hidden_shot_png 
		'steroid' :
			type_image.texture = steroid_png 
		'ice_cube' :
			type_image.texture = ice_cube_png
		'scissors' :
			type_image.texture = scissors_png
		
		
	flavor_text.text = designated_useable_item_offer.flavor_text
	

func _handle_mouse_entered():

	card_hover.visible = true

	if up_down_tween:
		up_down_tween.kill()

	position = starting_pos

	up_down_tween = create_tween()
	up_down_tween.set_loops()

	up_down_tween.tween_property(
		self,
		"position",
		starting_pos + Vector2(0, -5),
		0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	up_down_tween.tween_property(
		self,
		"position",
		starting_pos + Vector2(0, 5),
		0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _handle_mouse_exited():

	card_hover.visible = false

	if up_down_tween:
		up_down_tween.kill()
		up_down_tween = null

	position = starting_pos
