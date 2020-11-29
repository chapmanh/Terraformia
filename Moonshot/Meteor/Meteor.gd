extends Area2D
export var minSpeed: float = 0.9
export var maxSpeed: float = 1.1
export var minRotationRate: float = 45
export var maxRotationRate: float = -45
export var life: int = 3
export var deathTime = 5

# For incredibly janky animation, PLEASE REPLACE WITH AnimationSprite
# For the love of the Lord Almightly...
export var mouthTimer: float = 1.0
onready var mouthTimerCurrent := mouthTimer

onready var spriteOpen = $SpriteOpen
onready var spriteClosed = $SpriteClosed
onready var spriteDead = $SpriteDead

onready var game = get_tree().current_scene.get_node("Game")

var speed: float = 0
var direction: = Vector2(-1,0) # Move left by default
var rotationRate: float = 0

# Needs taking out, moving back into EnemySpawn
var lvl : int = 1

signal killed

func _ready():
#	printt("Viewport", get_viewport(), get_tree().root) # Game's viewport.
#	printt("Current Scene", get_tree().current_scene) # Active scene root.
#	printt("Local Scene", get_local_scene_root(self)) # The nearest TSCN root.
	speed *= rand_range(minSpeed, maxSpeed)
	rotationRate = rand_range(minRotationRate, maxRotationRate)
	spriteOpen.hide()
	spriteDead.hide()
	if global_position.y < 0:
		direction = Vector2(-1, 1).normalized()
		rotation = direction.angle() - PI
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
	
	
func get_local_scene_root(p_node : Node) -> Node:
	while(p_node and not p_node.filename):
		p_node = p_node.get_parent()
	return p_node as Node
	
func lvl_up(spawnRateInc: float, speedInc: float):
	
	lvl += 1
	
	print(lvl)
	
func damage(amount: int):
	life -= amount
	if life <= 0:
		die(10)
		
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


func _on_Meteor_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_floor"):
		die(0)
