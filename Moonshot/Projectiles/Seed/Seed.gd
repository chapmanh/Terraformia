extends Area2D

onready var animationPlayer = $AnimationPlayer

export var speed: float = 500
export var drag: float = 100

func _physics_process(delta: float) -> void:
	position.y += speed * delta
	position.x -= drag * delta




func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Seed_area_entered(area: Area2D) -> void:
	if area.is_in_group("fertile"):
		speed = 0
		animationPlayer.play("grow")
