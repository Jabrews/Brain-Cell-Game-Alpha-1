extends Node

# componnets
@onready var bar : Sprite2D = $"../Bar"
@onready var off_display : Control = $"../OffDisplay"
@onready var none_display : Control = $"../NoneDisplay"


func _switch(screen_type : String) :

	toggle_screens_off()
	
	match screen_type :	
		'on' : 
			bar.visible = true
		'off' :
			off_display.visible = true
		'none' :
			none_display.visible = true

func toggle_screens_off() :
	bar.visible = false
	off_display.visible = false
	none_display.visible = false
	
	
