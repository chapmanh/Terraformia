extends Area2D
export var minSpeed: float = 10
export var maxSpeed: float = 100
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

var speed: float = 0
var rotationRate: float = 0

func _ready():
	var mouthTimerCurrent := mouthTimer
	speed = rand_range(minSpeed, maxSpeed)
	rotationRate = rand_range(minRotationRate, maxRotationRate)
	spriteOpen.hide()
	spriteDead.hide()
	print(spriteOpen.visible)
	
	
func _process(delta: float) -> void:
	# Butchered animation attempt, feel free to upgrade with AnimatedSprite
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
	position.x -= speed * delta
	
func damage(amount: int):
	life -= amount
	if life <= 0:
		spriteClosed.hide()
		spriteOpen.hide()
		spriteDead.show()
		$CollisionPolygon2D.set_deferred("disabled", true)
		#queue_free()

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
