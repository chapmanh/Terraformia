extends Area2D

onready var animationPlayer = $AnimationPlayer
onready var airTimer = $AirTimer
onready var sprite = $Sprite

export var speed: float = 500
export var drag: float = 100

func _ready() -> void:
	airTimer.start()

func _physics_process(delta: float) -> void:
	position.y += speed * delta
	position.x -= drag * delta


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Seed_area_entered(area: Area2D) -> void:
	if area.is_in_group("fertile"):
		speed = 0
		if not airTimer.is_stopped():
			animationPlayer.play("grow")
			airTimer.queue_free() # Kill it, so no timeout trigger


func _on_AirTimer_timeout() -> void:
	animationPlayer.play("shrivel")
