extends Area2D

var plBullet := preload("res://Bullet/Bullet.tscn")

#onready var animatedSprite := $AnimatedSprite

onready var firingPositions := $FiringPositions
onready var fireDelayTimer := $FireDelayTimer
onready var invincibilityTimer := $InvincibilityTimer

# Ship Damage Sprites
onready var shipSprites := [$Ship_0, $Ship_1, $Ship_2, $Ship_3]

export var speed: float = 100.0
export var fireDelay: float = 0.1 
export var invincibility: float = 2.0
export var lifeMax: int = 4 # 0 = dead
export var life: int = 4 # 0 = dead
var vel := Vector2(0,0)

func _ready() -> void:
	for sprite in range(1, len(shipSprites)):
		shipSprites[sprite].visible = false

func _process(delta):
	# Animate with animatedSprite once implemented, placeholder names/examples
#	if vel.x < 0:
#		animatedSprite.play("Left")
#
#	elif vel.x > 0:
#		animatedSprite.play("Right")
#
#	else:
#		animatedSprite.play("Straight")
		
	# Check if shooting
	if Input.is_action_pressed("game_fire_primary") and fireDelayTimer.is_stopped():
		fireDelayTimer.start(fireDelay)
		for child in firingPositions.get_children():
			var bullet = plBullet.instance()
			bullet.global_position = child.global_position
			get_tree().current_scene.add_child(bullet)
	
	# Collision detection: (returns false if array is empty)
	if get_overlapping_areas() and invincibilityTimer.is_stopped():
		invincibilityTimer.start()
		print("Ow!")
		damage(1)
		print(life)
	
func _physics_process(delta: float) -> void:
	var dirVec := Vector2(0,0)
	
	if Input.is_action_pressed("game_left"):
		dirVec.x = -1
	
	elif Input.is_action_pressed("game_right"):
		dirVec.x = 1
	
	if Input.is_action_pressed("game_up"):
		dirVec.y = -1
	
	elif Input.is_action_pressed("game_down"):
		dirVec.y = 1
	
	vel = dirVec.normalized() * speed
	
	position += vel * delta
	
	# Make sure player stays in screen
	var viewRect := get_viewport_rect()
	position.x = clamp(position.x, 0, viewRect.size.x)
	position.y = clamp(position.y, 0, viewRect.size.y)



func damage(amount: int): # amount not yet implemented, all hits = 1
	life -= 1
	if life <= 0:
		die()
	else:
		var missingLife: int = lifeMax - life
		shipSprites[missingLife].visible = true
		shipSprites[missingLife -1].visible = false
	
	
		
func die():
	queue_free()
