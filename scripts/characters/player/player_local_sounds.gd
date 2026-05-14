extends Node

# component sounds
@onready var s_btn_press_failed : AudioStreamPlayer3D = $BtnPressFailed
@onready var s_drop_item : AudioStreamPlayer3D = $DropItem
@onready var s_pickup_item : AudioStreamPlayer3D = $PickupItem
@onready var s_panel_cell_loaded : AudioStreamPlayer3D = $PanelCellLoaded
@onready var s_shot_used : AudioStreamPlayer3D = $ShotUsed
@onready var s_btn_press_success : AudioStreamPlayer3D = $BtnPressSuccess
@onready var s_cell_container_pickup : AudioStreamPlayer3D =$CellContainerPickup
@onready var s_cell_container_dropped : AudioStreamPlayer3D = $CellContainerDropped
@onready var s_hidden_interprter_all_jolt : AudioStreamPlayer3D = $HiddenInterpreterAllJolt
@onready var s_prisoner_selected : AudioStreamPlayer3D = $PrisonerSelected


func _ready() -> void:
	GLPlayerLocalSoundsBus.connect(
		'sound_btn_press_failed',
		_handle_sound_btn_press_failed
	)
	GLPlayerLocalSoundsBus.connect(
		'sound_item_dropped',
		_handle_sound_item_dropped
	)
	GLPlayerLocalSoundsBus.connect(
		'sound_item_pickup',
		_handle_sound_item_pickup
	)
	GLPlayerLocalSoundsBus.connect(
		'sound_panel_cell_loaded',
		_handle_sound_panel_cell_loaded
	)
	GLPlayerLocalSoundsBus.connect('sound_shot_used', _handle_sound_shot_used)
	GLPlayerLocalSoundsBus.connect('sound_btn_press_success', _handle_sound_btn_press_success)
	GLPlayerLocalSoundsBus.connect('sound_cell_container_pickup', _handle_cell_container_pickup)
	GLPlayerLocalSoundsBus.connect('sound_cell_container_dropped', _handle_cell_container_dropped)
	GLPlayerLocalSoundsBus.connect('sound_hidden_stat_interpreter_all_jolt', _handle_hidden_stat_interpreter_all_jolt)
	GLPlayerLocalSoundsBus.connect('prisoner_selected', _handle_prisoner_selected)


func _handle_sound_btn_press_failed() -> void:
	play_sound(s_btn_press_failed)

func _handle_sound_btn_press_success() -> void :
	play_sound(s_btn_press_success)


func _handle_sound_item_dropped() -> void:
	play_sound(s_drop_item)


func _handle_sound_item_pickup() -> void:
	play_sound(s_pickup_item)


func _handle_sound_panel_cell_loaded() -> void:
	play_sound(s_panel_cell_loaded)

func _handle_sound_shot_used() -> void :
	play_sound(s_shot_used)

func _handle_cell_container_pickup() -> void:
	play_sound(s_cell_container_pickup)

func _handle_cell_container_dropped() -> void:
	play_sound(s_cell_container_dropped)

func _handle_hidden_stat_interpreter_all_jolt() -> void : 
	play_sound(s_hidden_interprter_all_jolt)

func _handle_prisoner_selected() : 
	play_sound(s_prisoner_selected)

func play_sound(sound_player : AudioStreamPlayer3D) -> void:
	
	if not sound_player:
		push_error('sound audiostream not found in player_local_sounds ')
	
	# restart sound cleanly
	sound_player.stop()
	sound_player.play()
