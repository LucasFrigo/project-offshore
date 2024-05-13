extends Node3D


func _ready():
	var viewport = $Viewport
	var quad_mesh = $Quadmesh
	
	quad_mesh.material_override.albedo_texture = viewport.get_texture()
