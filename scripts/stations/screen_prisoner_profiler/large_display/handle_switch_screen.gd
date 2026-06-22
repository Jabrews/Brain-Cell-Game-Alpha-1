extends Node

# componnets
@onready var bar : Sprite2D = $"../Bar"
@onready var off_display : Control = $"../OffDisplay"


func _switch(screen_type : String) :

	toggle_screens_off()
	
	match screen_type :	
		'on' : 
			bar.visible = true
		'off' :
			off_display.visible = true

func toggle_screens_off() :
	bar.visible = false
	off_display.visible = false
	
	
