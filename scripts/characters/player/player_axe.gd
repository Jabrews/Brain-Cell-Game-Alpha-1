extends Node3D 

var flesh_bug_refrence : FleshBug

# componnets
@onready var can_swing_delay_timer : Timer = $CanSwingDelayTimer
var can_swing : bool = true

func _ready() -> void:
	GLPlayerState.connect('toggle_player_picked_up_axe_mount', _handle_toggle_player_picked_up_axe_mount)
	
func _handle_toggle_player_picked_up_axe_mount(toggleValue : bool) :
	if toggleValue :
		visible = true
	else :
		visible = false
		
func _process(_delta: float) -> void:
	
	# if not visible, the axe isnt being held
	if visible == false :
		return
		
	if Input.is_action_just_pressed('attack') and can_swing :	
		
		play_swing_animation()
		
		GLPlayerLocalSoundsBus.emit_signal('sound_axe_swing')
		
		if flesh_bug_refrence :
			var player_refrence : CharacterBody3D = GLPlayerState.player_refrence
			flesh_bug_refrence.take_damange(1, player_refrence.global_position)
		
		can_swing_delay_timer.start()
		can_swing = false
		
		

func play_swing_animation() : 
	pass


func _on_hurt_box_body_entered(body: Node3D) -> void:
	if GLPlayerState.player_holding_axe_mount == true :
		if body.is_in_group('flesh_bug') :
			flesh_bug_refrence = body

func _on_hurt_box_body_exited(body: Node3D) -> void:
	if body.is_in_group('flesh_bug') :
		flesh_bug_refrence = null
	
func _on_can_swing_delay_timer_timeout() -> void:
	can_swing = true
