extends TextureRect

func _ready() -> void:
	material.set_shader_param("Scroll Speed", 0)
	
func _process(delta: float) -> void:
	material.set_shader_param("Scroll Speed", 1)
	print("dwa")
