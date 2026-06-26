extends Label

var opacity_tween : Tween


func _ready() -> void:
	GLPrisonerProfilerComponentsBus.connect(
		"station_feedback_requested",
		_handle_feedback
	)


func _handle_feedback(type: String, data: Dictionary) -> void:
	if type != "spare_label":
		return
	
	var selected_icon: Dictionary = data["data"]
	
	var spare_symbol_type: String = selected_icon["type"]
	var direction: String = selected_icon["direction"]
	
	initiate_label(spare_symbol_type, direction)


func initiate_label(spare_symbol_type: String, direction: String) -> void:
	
	var direction_text: String
	
	match spare_symbol_type :	
		'bad_mutation' :
			spare_symbol_type = 'Bad Mutations'
		'good_mutation' : 
			spare_symbol_type = 'Good Mutations'
		'defect' :
			spare_symbol_type = 'Defect'
		'energy' :
			spare_symbol_type = 'Energy'
	
	match direction:
		"up":
			direction_text = "Increase"
		"down":
			direction_text = "Decrease"
		_:
			direction_text = "NONE"

	text = spare_symbol_type + " : "  + direction_text
	
	visible = true
	modulate.a = 1.0
	
	if opacity_tween:
		opacity_tween.kill()
	
	opacity_tween = create_tween()
	opacity_tween.tween_property(
		self,
		"modulate:a",
		0.0,
		3.0
	)
	
	opacity_tween.finished.connect(func():
		visible = false
	)
	
	
	
	
	
