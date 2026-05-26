extends Node

# components
@onready var parent_node : CharacterBody3D = $".."
@onready var player_regain_health_timer : Timer = $PlayerRegainHealthTimer



func _ready() -> void:
	GLPlayerState.connect('increment_player_health', _handle_increment_player_health)
	player_regain_health_timer.connect('timeout', _handle_regain_health_timer_timeout)
	
func _handle_increment_player_health(damange_amount : int) :
	
	# if invincible do nothing	
	if GLPlayerState.player_invincible :
		return
	
	
	GLPlayerState.player_health += damange_amount
	
	# clamp health
	GLPlayerState.player_health = clamp(GLPlayerState.player_health, 0, 3)

	GLPlayerState.emit_signal("player_health_changed")
	
	# if this is negative damange
	if damange_amount < 0 :	
		player_regain_health_timer.start()
	

	if GLPlayerState.player_health <= 0:
		parent_node.queue_free()
		
func _handle_regain_health_timer_timeout() :
	if GLPlayerState.player_health < 4 :
		GLPlayerState.player_health += 1
		GLPlayerState.emit_signal("player_health_changed")
		player_regain_health_timer.start()
