extends Area2D
export var minSpeed: float = 1.2
export var maxSpeed: float = 1.8
export var minRotationRate: float = 45
export var maxRotationRate: float = -45
export var life: int = 1
export var deathTime = 5

# For incredibly janky animation, PLEASE REPLACE WITH AnimationSprite
# For the love of the Lord Almightly...
export var mouthTimer: float = 0.1
onready var mouthTimerCurrent := mouthTimer

onready var spriteOpen = $SpriteOpen
onready var spriteClosed = $SpriteClosed
onready var spriteDead = $SpriteDead

onready var game = get_tree().current_scene


onready var player := get_node("../../Player") # needs looking into...

var speed: float = 0
var direction: = Vector2(-1,0) # Move left by default
var rotationRate: float = 0

func _ready():
	speed *= rand_range(minSpeed, maxSpeed)
	rotationRate = 0
	spriteOpen.hide()
	spriteDead.hide()
	direction = (player.global_position - global_position).normalized()
	rotation = direction.angle() - PI


func _process(delta: float) -> void:
	# Butchered animation attempt, I AM SORRY
	if mouthTimerCurrent <= 0:
		if spriteOpen.visible:
			spriteOpen.hide()
			spriteClosed.show()
			
		elif spriteClosed.visible:
			spriteClosed.hide()
			spriteOpen.show()
			
		mouthTimerCurrent = mouthTimer
	
	mouthTimerCurrent -= delta
	#print(mouthTimerCurrent)
	
	
func _physics_process(delta: float) -> void:
	rotation_degrees += rotationRate * delta
	global_position += direction * speed * delta


func lvl_up(spawnRateInc: float, speedInc: float):
	speed = speed * (1 + speedInc)


func damage(amount: int):
	life -= amount
	if life <= 0:
		die(15)
		
func die(n):
	spriteClosed.hide()
	spriteOpen.hide()
	spriteDead.show()
	game.score_inc(n)
	$CollisionPolygon2D.set_deferred("disabled", true)
	$AudioDeath.play()
	$DeathTimer.start()

# Leave screen = Remove
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

# Dead for a while = Remove
func _on_DeathTimer_timeout() -> void:
	queue_free()


func _on_Meteor2_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_floor"):
		die(0)
