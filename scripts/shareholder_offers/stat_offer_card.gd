extends TextureRect

# components
@onready var type_image : TextureRect = $TypeImage
@onready var card_hover : TextureRect = $CardHover
@onready var flavor_text : Label = $FlavorText
@onready var shareholder_offer_manager : Node = $"../.."
# type img textures
@onready var effects_breeding_img : Texture = preload("res://models/share_holder_offer_card/effects_breeding.png")
@onready var effects_defect_img : Texture = preload("res://models/share_holder_offer_card/effects_defect.png")
@onready var effects_prisoner_img : Texture = preload("res://models/share_holder_offer_card/prisoner_effect.png")

var designated_stat_offer : StatOfferItem

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
			shareholder_offer_manager.handle_card_picked('stat', self)

func update(stat_offer : StatOfferItem) :
	
	position = starting_pos
	modulate.a = 1.0
	
	designated_stat_offer = stat_offer
	
	match designated_stat_offer.effect_type :
		'effects_prisoners' :
			type_image.texture = effects_prisoner_img
		'effects_breeding' :
			type_image.texture = effects_breeding_img
		'effects_defect' :
			type_image.texture = effects_defect_img
		
	flavor_text.text = designated_stat_offer.flavor_text
	
	

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
