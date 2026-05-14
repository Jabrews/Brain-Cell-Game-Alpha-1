extends Node


# componnets
@onready var screen_cell_breeding : Node2D = $BreedPreviewTv/TvFrontPannel/SubViewport/ScreenCellBreedingPreview


@export var cell_container_parent_node : Node 



func _ready() -> void:
	
	# once round ended reset curr_breeding attempts	
	GLGameManagerBus.connect('finale_turn_ended_new_round_proceed', _handle_next_round)
	

func _on_breed_confirm_btn_down() : 
	var cell_1 : BrainCell = screen_cell_breeding.left_brain_cell
	var cell_2 : BrainCell = screen_cell_breeding.right_brain_cell
	
	# stop if not both cells exist
	if cell_1 == null or cell_2 == null :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	elif IVCellBreeding.curr_cell_breeding_attempt == IVCellBreeding.max_cell_breeding_attempts :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_failed')
		return
	else :
		GLPlayerLocalSoundsBus.emit_signal('sound_btn_press_success')
		IVCellBreeding.curr_cell_breeding_attempt += 1	
		GLCellBreederBus.emit_signal('player_breeded_cells', cell_1, cell_2)
	
func _handle_next_round() :
	IVCellBreeding.curr_cell_breeding_attempt = 0
	# HACKY update new round manuely so the screen gets correct breeding attempt
	screen_cell_breeding._handle_next_round()
	
	
