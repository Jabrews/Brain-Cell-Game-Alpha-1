extends Node

enum Screen {
	LOADER,
	PREVIEW
}

var left_cell : BrainCell
var right_cell : BrainCell
var both_cells_valid : bool = false
var current_screen : Screen = Screen.LOADER

# components
@onready var cell_loading_left_seat : Node2D = $BreedPreviewTv/TvFrontPannel/SubViewport/ScreenBreedingLoader/SeatCellLoading/LeftSeat
@onready var cell_loading_right_seat : Node2D = $BreedPreviewTv/TvFrontPannel/SubViewport/ScreenBreedingLoader/SeatCellLoading/RightSeat
@export var cell_container_parent_node : Node

# screens
@onready var screen_seat_cells_loading : Node2D = $BreedPreviewTv/TvFrontPannel/SubViewport/ScreenBreedingLoader/SeatCellLoading
@onready var screen_new_cell_preview : Node2D = $BreedPreviewTv/TvFrontPannel/SubViewport/ScreenBreedingLoader/NewCellPreview

# ui
@onready var press_btn_to_see_result_label : Label = $BreedPreviewTv/TvFrontPannel/SubViewport/ScreenBreedingLoader/SeatCellLoading/PressBtnToSeeResult
@onready var cell_loading_symbol_manager : Control = $BreedPreviewTv/TvFrontPannel/SubViewport/ScreenBreedingLoader/SeatCellLoading/SymbolManager


func _handle_breeding_panel_cell_recieved(cell : BrainCell, side : String) -> void:
	match side:
		"left":
			_set_cell(cell, true)

		"right":
			_set_cell(cell, false)

		_:
			push_error("Invalid breeding side: " + side)
			return

	_update_breeding_state()


func _set_cell(cell : BrainCell, is_left_side : bool) -> void:
	if is_left_side:
		left_cell = cell
		cell_loading_left_seat._load(cell)
		cell_loading_symbol_manager.check_for_checkmarks("left", cell)
	else:
		right_cell = cell
		cell_loading_right_seat._load(cell)
		cell_loading_symbol_manager.check_for_checkmarks("right", cell)


func _update_breeding_state() -> void:
	both_cells_valid = left_cell != null and right_cell != null
	press_btn_to_see_result_label.visible = both_cells_valid

	if both_cells_valid:
		cell_loading_symbol_manager.check_for_symbols(left_cell, right_cell)
		return
	
	cell_loading_symbol_manager.hide_symbols()

	if current_screen == Screen.PREVIEW:
		_clear_preview()
		switch_screen(Screen.LOADER)


func _handle_confirm_btn_pressed() -> void:
	if not both_cells_valid:
		return

	match current_screen:
		Screen.LOADER:
			_show_breeding_preview()

		Screen.PREVIEW:
			GLCellBreederBus.emit_signal('player_breeded_cells', left_cell, right_cell)


func _show_breeding_preview() -> void:
	var simulated_cell : BrainCell = GAMECellBreeder._handle_player_simulate_breeded_cells(
		left_cell,
		right_cell
	)

	switch_screen(Screen.PREVIEW)

	screen_new_cell_preview._display_simulated_cell(
		left_cell,
		right_cell,
		simulated_cell
	)


func _clear_preview() -> void:
	screen_new_cell_preview._display_simulated_cell(null, null, null)


func switch_screen(new_screen : Screen) -> void:
	current_screen = new_screen

	screen_seat_cells_loading.visible = new_screen == Screen.LOADER
	screen_new_cell_preview.visible = new_screen == Screen.PREVIEW
