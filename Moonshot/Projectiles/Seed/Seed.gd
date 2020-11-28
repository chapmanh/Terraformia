extends Area2D

onready var animationPlayer = $AnimationPlayer
onready var airTimer = $AirTimer
onready var sprite = $Sprite
onready var collider = $CollisionShape2D
onready var audioShrivel = $AudioShrivel
onready var audioGrow = $AudioGrow

onready var game = get_tree().current_scene

export var speed: float = 500
export var drag: float = 240

func _ready() -> void:
	airTimer.start()

func _physics_process(delta: float) -> void:
	position.y += speed * delta
	position.x -= drag * delta


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_Seed_area_entered(area: Area2D) -> void:
	if area.is_in_group("ground"):
		speed = 0
		if area.is_in_group("fertile") and not airTimer.is_stopped():
			#print("fertile baby!")
			_grow()
		else:
			#print("fo' shrivel my nizzle")
			_shrivel()


func _on_AirTimer_timeout() -> void:
	_shrivel()
	
func _shrivel():
	if not animationPlayer.is_playing() and not audioShrivel.is_playing() and not audioGrow.is_playing():
		animationPlayer.play("shrivel")
		audioShrivel.play()


func _grow():
	if not audioShrivel.is_playing():
		animationPlayer.play("grow")
		audioGrow.play()
		airTimer.paused = true
		game.score_inc(25)
