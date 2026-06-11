extends Node


# components
@onready var cell_container_instance : PackedScene = preload('res://scenes/characters/cell_container/CellContainer.tscn')
@onready var spawn_position : Node3D = $SpawnPos

func _ready() -> void:
	GLCellManagerBus.connect('cell_breeded', _handle_cell_breeded) 
	
	
func _handle_cell_breeded(_old_cell_1, _old_cell_2, new_cell : BrainCell) :
	create_cell_container_instance(new_cell)


func create_cell_container_instance(cell : BrainCell) :
	var cell_container = cell_container_instance.instantiate()
	cell_container.name = cell.name
	cell_container.designated_brain_cell = cell
	
	var cell_container_parent_node : Node = get_parent().cell_container_parent_node 
	
	cell_container_parent_node.add_child(cell_container)
	cell_container.global_position = spawn_position.global_position
