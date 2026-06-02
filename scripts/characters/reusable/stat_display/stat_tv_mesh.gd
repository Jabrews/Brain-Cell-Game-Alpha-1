extends MeshInstance3D 

@onready var sub_viewport = $SubViewport

var player : CharacterBody3D # this is set by the stat displau detect raycast

func _ready() -> void:
	var tex = sub_viewport.get_texture()
	
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_texture = tex
	
	material_override = mat

func _process(_delta: float) -> void:
	if visible and player:
		var dir = player.global_transform.origin - global_transform.origin
		dir.y = 0  # ignore vertical tilt

		rotation.y = atan2(dir.x, dir.z)
