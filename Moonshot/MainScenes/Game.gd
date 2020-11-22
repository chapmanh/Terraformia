extends Node2D

var plMeteor := preload("res://Meteor/Meteor.tscn")
var score : int



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	
	
	# SHARER PARAMETERS ARE A PAIN TO FIND/CHANGE... 
	#$Ground/ScrollingBackground.material.set_shader_param("Scroll Speed", 0.0)
#	var ss = $Ground/ScrollingBackground.material.get_shader_param("Scroll Speed")
#	print(ss)
	new_game()

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	#get_tree().call_group("mobs", "queue_free")
	
	# Stop meteors spawning, as doing so without player can break game
	$EnemySpawn/EnemyGenerator/EnemyGenerationTimer.stop()

func new_game():
	score = 0
	print("Level: ", $EnemySpawn/EnemyGenerator.lvl)
	$Player.start(Vector2(300,300))
	$ScoreTimer.start()
	$EnemySpawn/EnemyGenerator/EnemyGenerationTimer.start()


func _on_ScoreTimer_timeout() -> void:
	score += 1
	print(score)


#func _on_MobTimer_timeout() -> void:
#	# Choose a random location on Path2D.
#	$MobPathRight/MobSpawnLocationRight.offset = randi()
#	# Create a Mob instance and add it to the scene.
#	var meteor = plMeteor.instance()
#
#	# Set the mob's direction perpendicular to the path direction.
#	var direction = $MobPathRight/MobSpawnLocationRight.rotation + PI / 2
#	# Set the mob's position to a random location.
#	meteor.position = $MobPathRight/MobSpawnLocationRight.position
#	# Add some randomness to the direction.
#	direction += rand_range(-PI / 4, PI / 4)
#	meteor.rotation = direction
#	# Set the velocity (speed & direction).
##	meteor.linear_velocity = Vector2(rand_range(meteor.minSpeed, meteor.maxSpeed), 0)
##	meteor.linear_velocity = meteor.linear_velocity.rotated(direction)
#	add_child(meteor)


func _on_Player_killed() -> void:
	game_over()


func _on_LevelTimer_timeout() -> void:
	print('next level')
	lvl_up(1000.0, 1000.0)

func lvl_up(spawnRateInc: float, speedInc: float):
	get_tree().call_group("mobs", "lvl_up", 0.5, 0.5)
