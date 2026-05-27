extends Node

# components
@export var player : CharacterBody3D

@onready var spawn_pos: Node3D = $SpawnPos
@onready var useable_item_scene: PackedScene = preload("res://scenes/useable/useable_item.tscn")

var current_id : int = 0


func _ready() -> void:
	connect_signals()
	spawn_turn_items()


func connect_signals():

	GLUsableItemBus.connect("useable_item_dropped", _handle_useable_item_dropped)
	GLUsableItemBus.connect('spawn_new_usable_items', spawn_turn_items)

	# next turn signal
	#GLCellCreatorBus.connect('procc', _handle_next_turn)


func spawn_turn_items():

	spawn_item_type(
		"defect_shot",
		true,
		3,
		IVUseableItemSpawner.defect_shots_to_spawn
	)

	spawn_item_type(
		"hidden_shot",
		false,
		0,
		IVUseableItemSpawner.hidden_shots_to_spawn
	)

	spawn_item_type(
		"steroid",
		false,
		0,
		IVUseableItemSpawner.steroids_to_spawn
	)


func spawn_item_type(
	item_type : String,
	item_has_energy : bool,
	item_energy : int,
	spawn_quantity : int
):

	for i in range(spawn_quantity):

		var new_item = UseableItemObject.new(
			0,
			item_type,
			item_has_energy,
			item_energy
		)

		create_item(new_item)


func create_item(useable_item_obj : UseableItemObject):

	var useable_item_instance = useable_item_scene.instantiate()

	add_child(useable_item_instance)

	useable_item_instance.global_position = spawn_pos.global_position

	current_id += 1

	var item_copy = UseableItemObject.new(
		current_id,
		useable_item_obj.item_type,
		useable_item_obj.item_has_energy,
		useable_item_obj.item_energy
	)

	useable_item_instance.designated_useable_item_obj = item_copy

	useable_item_instance.load_item(true)


func _handle_useable_item_dropped(useable_item_dropped : UseableItemObject):
	create_item_at_player(useable_item_dropped)


func create_item_at_player(useable_item_dropped : UseableItemObject):

	var useable_item_instance = useable_item_scene.instantiate()

	add_child(useable_item_instance)

	useable_item_instance.global_position = player.global_position

	var item_copy = UseableItemObject.new(
		useable_item_dropped.item_id,
		useable_item_dropped.item_type,
		useable_item_dropped.item_has_energy,
		useable_item_dropped.item_energy
	)

	useable_item_instance.designated_useable_item_obj = item_copy

	useable_item_instance.load_item(false, useable_item_dropped.item_energy)
