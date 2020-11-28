extends Area2D

var plBullet := preload("res://Projectiles/Bullet/Bullet.tscn")
var plSeed := preload("res://Projectiles/Seed/Seed.tscn")

signal health_updated(health)
signal killed()

#onready var animatedSprite := $AnimatedSprite

onready var primaryPositions := $PrimaryPositions
onready var primaryDelayTimer := $PrimaryDelayTimer

onready var secondaryPositions := $SecondaryPositions
onready var secondaryDelayTimer := $SecondaryDelayTimer

onready var invulnerabilityTimer := $InvulnerabilityTimer
onready var effectAnimation := $EffectAnimation

onready var audioDamage1 := $AudioDamage1
onready var audioDamage2 := $AudioDamage2
onready var audioPrimaryFire := $AudioPrimaryFire


# Ship Damage Sprites
onready var shipSprites := [
	$Sprites/Ship_0,
	$Sprites/Ship_1,
	$Sprites/Ship_2,
	$Sprites/Ship_3,
	]

export var speed: float = 100.0
export var primaryFireDelay: float = 0.1 
export var secondaryFireDelay: float = 2.0
export var invincibility: float = 2.0
export var max_health: float = 4 # 0 = dead

onready var health = max_health setget _set_health



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
	if Input.is_action_pressed("game_fire_primary") and primaryDelayTimer.is_stopped():
		primaryDelayTimer.start(primaryFireDelay)
		audioPrimaryFire.play()
		for child in primaryPositions.get_children():
			var bullet = plBullet.instance()
			bullet.global_position = child.global_position
			get_tree().current_scene.add_child(bullet)
			
		# Check if shooting
	if Input.is_action_pressed("game_fire_secondary") and secondaryDelayTimer.is_stopped():
		secondaryDelayTimer.start(secondaryFireDelay)
		for child in secondaryPositions.get_children():
			var Seed = plSeed.instance()
			Seed.global_position = child.global_position
			get_tree().current_scene.add_child(Seed)
	
	# Collision detection: (returns false if array is empty)
	if get_overlapping_areas():
		damage(1)
	
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
	position.y = clamp(position.y, 0, viewRect.size.y - 75)
	# Manually subtracting ground size to prevent flying through ground


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func damage(amount): # Could implement damage types here, with modifiers
	if invulnerabilityTimer.is_stopped():	
		invulnerabilityTimer.start()
		_set_health(health - amount)
		effectAnimation.play("damage")
		effectAnimation.queue("flash")
		if randi() % 2 == 0:
			audioDamage1.play()
		else:
			audioDamage2.play()
		
		
	
func kill():
	queue_free()

func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		if health == 0:
			kill()
			emit_signal("killed")
			$CollisionShape2D.set_deferred("disabled", true)
		else:
			var missingLife: int = max_health - health
			shipSprites[missingLife].visible = true
			shipSprites[missingLife -1].visible = false
	


func _on_InvulnerabilityTimer_timeout() -> void:
	effectAnimation.play("rest")
	
