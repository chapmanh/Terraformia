extends Node2D

var rotation_rate: float = 0.1
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


func _process(delta: float) -> void:
	rotation_degrees -= rotation_rate * delta


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
