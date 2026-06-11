extends Node

@onready var hidden_question_mark_sprites : Array[Sprite2D] = [
	$"../QuestionMark/QuestionStrength",
	$"../QuestionMark/QuestionIntelligence",
	$"../QuestionMark/QuestionCommunity"
]


func _handle(stat_1: BrainCellStat, stat_2 : BrainCellStat) -> bool :

	# strength 
	if stat_1.hidden or stat_2.hidden : 
		hide_corrisponding_stat_type(stat_1.type)
		return true
	else :
		return false

func hide_corrisponding_stat_type(stat_type : String) :
	match stat_type :
		'strength':
			hidden_question_mark_sprites[0].visible = true
		'intelligence' :
			hidden_question_mark_sprites[1].visible = true
		'community' :
			hidden_question_mark_sprites[2].visible = true	
	
