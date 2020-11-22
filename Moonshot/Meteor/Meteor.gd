extends Area2D
export var minSpeed: float = 0.9
export var maxSpeed: float = 1.1
export var minRotationRate: float = 45
export var maxRotationRate: float = -45
export var life: int = 20
export var deathTime = 5

# For incredibly janky animation, PLEASE REPLACE WITH AnimationSprite
# For the love of the Lord Almightly...
export var mouthTimer: float = 1.0
onready var mouthTimerCurrent := mouthTimer

onready var spriteOpen = $SpriteOpen
onready var spriteClosed = $SpriteClosed
onready var spriteDead = $SpriteDead

# Player info (Simple Meteor doesnt aim)
#onready var player := get_node("../../Player") # needs looking into...

var speed: float = 0
var direction: = Vector2(-1,0) # Move left by default
var rotationRate: float = 0

# Needs taking out, moving back into EnemySpawn
var lvl : int = 1

func _ready():
	speed *= rand_range(minSpeed, maxSpeed)
	rotationRate = rand_range(minRotationRate, maxRotationRate)
	spriteOpen.hide()
	spriteDead.hide()
	if global_position.y < 0:
		direction = Vector2(-1, 1).normalized()
	
	#direction = (player.global_position - global_position).normalized()


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
	
	lvl += 1
	
	print(lvl)
	
func damage(amount: int):
	life -= amount
	if life <= 0:
		die()
		
func die():
	spriteClosed.hide()
	spriteOpen.hide()
	spriteDead.show()
	$CollisionPolygon2D.set_deferred("disabled", true)
	$DeathTimer.start()

# Leave screen = Remove
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

# Dead for a while = Remove
func _on_DeathTimer_timeout() -> void:
	queue_free()
