extends Actor


# Declare member variables here.
export var speed = Vector2(400, 100) # How fast the player will move (pixels/sec).
var screen_size  # Size of the game window (eg. movement limitation)
var primary_projectile = load("res://Actors/Projectiles/Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Identify screen resolution to identify edges
	screen_size = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	var velocity = Vector2()  # The player's movement vector
	
	# First, calculate the direction the player wants to move
	if Input.is_action_pressed("game_right"):
		velocity.x += 1
		
	if Input.is_action_pressed("game_left"):
		velocity.x -= 1
		
	if Input.is_action_pressed("game_down"):
		velocity.y += 1
		
	if Input.is_action_pressed("game_up"):
		velocity.y -= 1
	
	# Normalise the direction vector to prevent diagonals being faster
	# Multiply by configurable speed Vector
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed 
	
	# Move dat ship, sliding against other objects
	move_and_slide(velocity)
	
	if Input.is_action_pressed("game_fire_primary"):
		shoot()
		pass
	
	# Restrict movement to within viewport
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func shoot():
	# Spawn a projectile
	var bullet = primary_projectile.instance()
	bullet.position.x = position.x
	bullet.position.y = position.y
	get_parent().add_child(bullet)
