extends Panel

func _ready() -> void:
	var shader_material: ShaderMaterial = material
	shader_material.set_shader_parameter("lightning_color",[Color("ee8695"), Color("4a7a96")].pick_random())
	shader_material.set_shader_parameter("size",randf_range(0.001,0.02))
	shader_material.set_shader_parameter("width",randf_range(0.25,1.0))
	shader_material.set_shader_parameter("speed",randf_range(2.0,10.0))
	shader_material.set_shader_parameter("cycle",randf_range(0.2,5.0))
