extends Node

# component question marks
@onready var strength_q_m : Sprite2D = $"../../Symbols/QuestionMarks/StrengthQuestionMark"
@onready var intelligence_q_m : Sprite2D = $"../../Symbols/QuestionMarks/IntelligenceQuestionMark"
@onready var community_q_m : Sprite2D = $"../../Symbols/QuestionMarks/CommunityQuestionMark"


func _handle_detect_question_mark(
	key,
	cell_left : BrainCell,
	cell_right : BrainCell
) : 
	
	var found_hidden_stat : bool = false
	
	match key : 
		
		'str' :
			if (
				cell_left.strength.hidden
				or cell_right.strength.hidden
			):
				found_hidden_stat = true
				
		'int' :
			if (
				cell_left.intelligence.hidden
				or cell_right.intelligence.hidden
			):
				found_hidden_stat = true
				
		'com' :
			if (
				cell_left.community.hidden
				or cell_right.community.hidden
			):
				found_hidden_stat = true
				
		_:
			push_error(
				'no key value found for _handle_detect_question_mark breeder symbol'
			)
		
	return found_hidden_stat


func _display_question_mark(stat_type : String) :
	
	match stat_type :
		
		'strength' :
			strength_q_m.visible = true
			
		'intelligence' :		
			intelligence_q_m.visible = true
			
		'community' :
			community_q_m.visible = true


func _reset_symbols() : 
	strength_q_m.visible = false
	intelligence_q_m.visible = false
	community_q_m.visible = false
	
