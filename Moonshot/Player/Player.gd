extends Area2D

var plBullet := preload("res://Projectiles/Bullet/Bullet.tscn")
var plSeed := preload("res://Projectiles/Seed/Seed.tscn")

signal health_updated(health)
signal killed()

onready var game = get_tree().current_scene.get_node("Game")

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

export var speed: float = 200.0
export var primaryFireDelay: float = 0.1 
export var secondaryFireDelay: float = 2.0
export var invincibility: float = 2.0
export var max_health: float = 4 # 0 = dead

onready var health = max_health setget _set_health

var controllable: bool = true



var vel := Vector2(0,0)

func _ready() -> void:
	effectAnimation.play("rest")
	controllable = true
	for sprite in range(1, len(shipSprites)):
		shipSprites[sprite].visible = false
		
	# WIP!!!
#	connect("killed", game, "call_deferred")

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
	if controllable:
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
	
	# Make sure player stays in screen
	var viewRect := get_viewport_rect()
	if controllable:
		position.x = clamp(position.x, 0, viewRect.size.x)
	else:
		position.y = clamp(position.y, 0, viewRect.size.y - 75)
	
	var dirVec: Vector2
	if controllable:
		dirVec = Vector2(0,0)
	elif global_position.y < viewRect.size.y - 75:
		dirVec = Vector2(0.5,1)
	else:
		dirVec = Vector2(-1,0)
		speed = 235
	
	if controllable:
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


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func damage(amount): # Could implement damage types here, with modifiers
	if invulnerabilityTimer.is_stopped():	
		invulnerabilityTimer.start()
		_set_health(health - amount)
		
		if randi() % 2 == 0:
			audioDamage1.play()
		else:
			audioDamage2.play()


func _set_health(value):
	var prev_health = health
	health = clamp(value, 0, max_health)
	if health != prev_health:
		emit_signal("health_updated", health)
		effectAnimation.stop()
		effectAnimation.play("damage")
		effectAnimation.queue("flash")
		if health == 0:
			emit_signal("killed")
			effectAnimation.stop()
			effectAnimation.queue("fadeOut")
			$CollisionShape2D.set_deferred("disabled", true)
			$DeathTimer.start()
		
		else:
			var missingLife: int = max_health - health
			shipSprites[missingLife].visible = true
			shipSprites[missingLife -1].visible = false
			


func _on_InvulnerabilityTimer_timeout() -> void:
	if health > 0:
		effectAnimation.play("rest")


func _on_Player_killed() -> void:
	controllable = false
	game.game_over()


func _on_DeathTimer_timeout() -> void:
	queue_free()
