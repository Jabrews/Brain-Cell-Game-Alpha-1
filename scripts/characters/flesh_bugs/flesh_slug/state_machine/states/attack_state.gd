extends Node

# components
@onready var parent_slug : CharacterBody3D = $"../.."
@onready var state_machine : Node = $".."
@onready var tail_rattle_sound : AudioStreamPlayer3D = $"../../TailRattleSound"
@onready var bite_sound : AudioStreamPlayer3D = $"../../BiteSound"
@onready var post_bite_delay_timer : Timer = $PostBiteDelay

var can_bite = true

func _ready() -> void: 
	post_bite_delay_timer.connect('timeout', _handle_post_bite_delay_timeout)

func state_start() : 
	
	can_bite = true
	
	
	tail_rattle_sound.play()
	
	# scale up PLACEHOLDER FOR MODEL
	parent_slug.scale = Vector3(1.5, 1.5, 1.5)
	
	if can_bite :
		
		# bite delay
		await get_tree().create_timer(0.3).timeout
		
		if can_bite :
			bite_sound.play()
			GLPlayerState.emit_signal('increment_player_health', -1)
			can_bite = false 
			post_bite_delay_timer.start()
	
	
	


func state_process(_delta) : 
	pass


func state_end() : 
	tail_rattle_sound.stop()
	
	can_bite = false
	
	# scale up PLACEHOLDER FOR MODEL
	parent_slug.scale = Vector3(1, 1, 1)

func _handle_post_bite_delay_timeout() :
	can_bite = true
