extends KinematicBody2D

# Initialise movement as vector
export var velocity = Vector2()

func _ready():
	# Once ready, define desired velocity
	velocity.x = 600
	
func _physics_process(delta: float) -> void:
	move_and_slide(velocity)
