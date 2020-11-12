extends Actor


# Declare member variables here.
export var speed = Vector2(400, 100) # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window (eg. movement limitation)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
#	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("game_right"):
		velocity.x += 1
	if Input.is_action_pressed("game_left"):
		velocity.x -= 1
	if Input.is_action_pressed("game_down"):
		velocity.y += 1
	if Input.is_action_pressed("game_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
#		$AnimatedSprite.play() #Animation while moving only?
#	else:
#		$AnimatedSprite.stop() #Animation while moving only?
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	# Thrusters Animation, part of same godot scene? I think so...
	
	
	# Code for animation while moving on the x/y axis respectively
#	if velocity.x != 0: #walking left/right animation
#		$AnimatedSprite.animation = "walk"
#		#$AnimatedSprite.flip_v = false
#		$AnimatedSprite.flip_h = velocity.x < 0
#	elif velocity.y != 0:
#		$AnimatedSprite.animation = "up"
#		$AnimatedSprite.flip_v = velocity.y > 0
