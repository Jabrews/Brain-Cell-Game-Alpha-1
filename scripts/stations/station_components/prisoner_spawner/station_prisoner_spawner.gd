extends Node

# componnets
@export var prisoners_parent_node : Node
@onready var prisoner_spots : Array[Node3D] = [
	$PrisonerSpawnSpots/Spot1,
	$PrisonerSpawnSpots/Spot2,
	$PrisonerSpawnSpots/Spot3,
	$PrisonerSpawnSpots/Spot4,
]
@onready var prisoner_instance : PackedScene = preload("res://scenes/characters/prisoner/Prisoner.tscn")

func _ready() -> void:
	GLCellCreatorBus.connect('get_newest_prisoner_cells', _handle_get_newest_prisoner_cells)
	GLCellManagerBus.connect('prisoner_picked_by_player', _handle_prisoner_picked_by_player)
	
func _handle_get_newest_prisoner_cells(new_prisoner_cells : Array[BrainCell]) :
	
	# reset all seats 
	for spot in prisoner_spots:
		spot.is_being_sat_in = false
	

	
	for cell : BrainCell in new_prisoner_cells :
		create_cell_instance(cell)
	

func create_cell_instance(designated_brain_cell : BrainCell) -> void:

	var prisoner = prisoner_instance.instantiate()
	prisoner.designated_brain_cell = designated_brain_cell

	prisoners_parent_node.add_child(prisoner)

	for spot in prisoner_spots:
		if not spot.is_being_sat_in:

			prisoner.global_position = spot.global_position
			spot.is_being_sat_in = true

			return

	push_error("No available prisoner spots")
	prisoner.queue_free()
	
	
# player get limited choice per each batch
func _handle_prisoner_picked_by_player(_prisoner_cell : BrainCell) :
	var next_picked_pris = IVPrisonerSpawner.curr_picked_pris_per_turn + 1
	
	# if we've picked as many as possible
	if next_picked_pris >= IVPrisonerSpawner.max_picked_pris_per_turn :
		# delete other prisoners once we pick max
		GLCellManagerBus.emit_signal('delete_remaining_prisoners')
		IVPrisonerSpawner.curr_picked_pris_per_turn = 0
	else :
		IVPrisonerSpawner.curr_picked_pris_per_turn = next_picked_pris
	
	
