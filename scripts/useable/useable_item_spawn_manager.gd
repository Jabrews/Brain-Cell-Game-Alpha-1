extends Node

# components
@export var player : CharacterBody3D
@onready var spawn_pos: Node3D = $SpawnPos
@onready var useable_item_scene: PackedScene = preload("res://scenes/useable/useable_item.tscn")

var current_id : int = 0

func _ready() -> void:
	connect_signals()
	spawn_item_batch()
	
func connect_signals():
	GLUsableItemBus.connect('useable_item_dropped', _handle_useable_item_dropped)

func spawn_item_batch():
	var defect_shots_to_spawn = IVUseableItemSpawner.defect_shots_to_spawn
	
	var new_defect_shot = UseableItemObject.new(
		0, # dont set id yet
		'defect_shot', 
		true,
		3
	)
	
	create_loop(new_defect_shot, defect_shots_to_spawn)

	var hidden_shots_to_spawn = IVUseableItemSpawner.hidden_shots_to_spawn
	
	var new_hidden_shot = UseableItemObject.new(
		0, # dont set id yet
		'hidden_shot', 
		false,
		0,
	) 

	create_loop(new_hidden_shot, hidden_shots_to_spawn)

func create_loop(useable_item_obj : UseableItemObject, spawn_quantity : int):
	for i in range(spawn_quantity):
		create_item(useable_item_obj)

func create_item(useable_item_obj : UseableItemObject):
	var useable_item_instance = useable_item_scene.instantiate()
	add_child(useable_item_instance)
	useable_item_instance.global_position = spawn_pos.global_position
	
	current_id += 1
	
	# IMPORTANT: duplicate object so each item is independent
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
	
	# IMPORTANT: duplicate dropped state
	var item_copy = UseableItemObject.new(
		useable_item_dropped.item_id,
		useable_item_dropped.item_type,
		useable_item_dropped.item_has_energy,
		useable_item_dropped.item_energy
	)
	
	useable_item_instance.designated_useable_item_obj = item_copy
	useable_item_instance.load_item(false, useable_item_dropped.item_energy)
