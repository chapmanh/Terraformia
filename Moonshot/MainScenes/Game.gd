extends Node2D

onready var highScoreLabel = find_node("highScoreLabel")
onready var highScores = $HighScores

onready var levelTimer = $LevelTimer
onready var enemySpawn = $EnemySpawn
onready var enemyGenTimer = $EnemySpawn/EnemyGenerator/EnemyGenerationTimer

var plPlayer := preload("res://Player/Player.tscn")

# Score board stuff
var score : int = 0
var scoreActive: bool = false

var playerName: String = "Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	highScores.visible = false
	highScoreLabel.text = "0"
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
	$GameWaitTimer.stop()
	enemySpawn.stop_spawn()
	
	# Stop level increase
	$LevelTimer.stop()
	
	# freeze & display scores
	scoreActive = false
	highScores.newAttempt([playerName, score])
	highScores.visible = true
	
	$HighScores/APHighScores.play("fadeIn")
	highScores.buttonRestart.disabled = false
	

func new_game():
	$HighScores/APHighScores.play("fadeOut")
	scoreActive = true
	score_inc(-score)
	print("Level: ", $EnemySpawn.lvl)
	$ScoreTimer.start()
	levelTimer.start()
	
	$AudioBGM.play()
	_spawn_player(Vector2(100,300))
	
	# Ready time (links to spawn start)
	$GameWaitTimer.start(7.5)
	
	# Kill any mobs
	get_tree().call_group("mobs", "queue_free")
	
func _spawn_player(pos):
	var player_instance = plPlayer.instance()
	player_instance.global_position = pos
	add_child(player_instance)

func _on_GameWaitTimer_timeout() -> void:
	enemySpawn.start_spawn()

func _on_ScoreTimer_timeout() -> void:
	score_inc(0)


func _on_Player_killed() -> void:
	game_over()


func lvl_up(spawnRateInc: float, speedInc: float):
	get_tree().call_group("mobs", "lvl_up", 0.5, 0.5)
	
func score_inc(n):
	if scoreActive == true:
		score += n
		highScoreLabel.text = str(score)



