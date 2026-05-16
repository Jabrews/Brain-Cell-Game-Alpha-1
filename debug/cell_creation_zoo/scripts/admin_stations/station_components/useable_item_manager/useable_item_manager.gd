extends Node

# components
@export var player : CharacterBody3D
@onready var spawn_pos: Node3D = $SpawnItemPos
@onready var useable_item_scene: PackedScene = preload("res://scenes/useable/useable_item.tscn")

var players_useable_items : Array[UseableItemObject] = []
var current_id : int = 0


func _ready() -> void:
	connect_signals()
	
func connect_signals():
	GLUsableItemBus.connect('useable_item_dropped', _handle_useable_item_dropped)
	
	# new signals
	GLUseableItemManagerBus.connect('useable_item_changed', _handle_useable_item_changed)
	GLUseableItemManagerBus.connect('useable_item_deleted', _handle_useable_item_deleted)

func _spawn_item_btn_pressed(spawn_item_type : String) :
	
	var item_to_spawn : UseableItemObject
	
	# increment id	
	current_id += 1	
	
	match spawn_item_type : 
		'defect' :
			item_to_spawn = UseableItemObject.new(
				current_id,
				'defect_shot', 
				true,
				3
			)
		'hidden' :
			item_to_spawn = UseableItemObject.new(
				current_id,
				'hidden_shot', 
				false,
				0,
			) 
		_: 
			push_error('invalid item type for useable_item_manager')
	
	create_item(item_to_spawn)
	
	# add to items array
	players_useable_items.append(item_to_spawn)
	

func create_item(useable_item_obj : UseableItemObject):
	var useable_item_instance = useable_item_scene.instantiate()
	add_child(useable_item_instance)
	useable_item_instance.global_position = spawn_pos.global_position
	
	# IMPORTANT: duplicate object so each item is independent
	var item_copy = UseableItemObject.new(
		useable_item_obj.item_id,
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

func _handle_useable_item_changed(new_useable_item : UseableItemObject) :
	
	var new_player_items : Array[UseableItemObject]= []
	
	for useable_item in players_useable_items : 
		if useable_item.item_id == new_useable_item.item_id :
			new_player_items.append(new_useable_item)
		else :
			new_player_items.append(useable_item)
	
	players_useable_items = new_player_items
	

func _handle_useable_item_deleted(useable_item_id : int) :
	
	var new_player_items : Array[UseableItemObject] = []	
	
	for useable_item in players_useable_items :
		if useable_item.item_id != useable_item_id :
			new_player_items.append(useable_item)
	
	
	players_useable_items = new_player_items
	
