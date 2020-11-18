extends Node2D

var plMeteor := preload("res://Meteor/Meteor.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _on_MobTimer_timeout() -> void:
	# Choose a random location on Path2D.
	$MobPathRight/MobSpawnLocationRight.offset = randi()
	# Create a Mob instance and add it to the scene.
	var meteor = plMeteor.instance()
	
	# Set the mob's direction perpendicular to the path direction.
	var direction = $MobPathRight/MobSpawnLocationRight.rotation + PI / 2
	# Set the mob's position to a random location.
	meteor.position = $MobPathRight/MobSpawnLocationRight.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	meteor.rotation = direction
	# Set the velocity (speed & direction).
#	meteor.linear_velocity = Vector2(rand_range(meteor.minSpeed, meteor.maxSpeed), 0)
#	meteor.linear_velocity = meteor.linear_velocity.rotated(direction)
	add_child(meteor)

