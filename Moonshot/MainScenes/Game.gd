extends Node2D

onready var highScoreLabel = find_node("highScoreLabel")
onready var highScores = $HighScores

var plMeteor := preload("res://Meteor/Meteor.tscn")
var score : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	highScores.visible = false
	new_game()
	
	# Initialise ground scroll speed via shaders
	
	# SHARER PARAMETERS ARE A PAIN TO FIND/CHANGE... 
	#$Ground/ScrollingBackground.material.set_shader_param("Scroll Speed", 0.0)
#	var ss  = $Ground/ScrollingBackground.material.set_shader_param("Scroll Speed", 500)
#	print(ss) # Returns 0?

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	#get_tree().call_group("mobs", "queue_free")
	
	# Stop meteors spawning, as doing so without player can break game
	$EnemySpawn/EnemyGenerator/EnemyGenerationTimer.stop()
	
	# Stop level increase
	$LevelTimer.stop()
	
	# Display scores
	highScores.visible = true
	$HighScores/APHighScores.play("fadeIn")
	

func new_game():
	score = 0
	print("Level: ", $EnemySpawn.lvl)
	$Player.start(Vector2(300,300))
	$ScoreTimer.start()
	$EnemySpawn/EnemyGenerator/EnemyGenerationTimer.start()


func _on_ScoreTimer_timeout() -> void:
	score_inc(1)


func _on_Player_killed() -> void:
	game_over()


func _on_LevelTimer_timeout() -> void:
	print('next level')
	lvl_up(1.0, 1.0)

func lvl_up(spawnRateInc: float, speedInc: float):
	get_tree().call_group("mobs", "lvl_up", 0.5, 0.5)
	
func score_inc(n):
	score += n
	highScoreLabel.text = str(score)
