extends Node2D

onready var highScoreLabel = find_node("highScoreLabel")
onready var highScores = $HighScores

onready var levelTimer = $LevelTimer
onready var enemySpawn = $EnemySpawn
onready var enemyGenTimer = $EnemySpawn/EnemyGenerator/EnemyGenerationTimer

onready var audioBGM = $AudioBGM
onready var audioBGMTween = $AudioBGM/Tween

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
	
	# Initialise ground scroll speed via shaders
	
	# SHARER PARAMETERS ARE A PAIN TO FIND/CHANGE... 
	#$Ground/ScrollingBackground.material.set_shader_param("Scroll Speed", 0.0)
#	var ss  = $Ground/ScrollingBackground.material.set_shader_param("Scroll Speed", 500)
#	print(ss) # Returns 0?


func game_over() -> void:
	$ScoreTimer.stop()
	#get_tree().call_group("mobs", "queue_free")
	
	# Stop meteors spawning, as doing so without player can break game
	$GameWaitTimer.stop()
	enemySpawn.stop_spawn()
	
	# Stop level increase
	$LevelTimer.stop()
	
	# freeze & display scores
	scoreActive = false
	highScores.newAttempt([playerName, score])
	
	highScores.game_over()
	highScores.buttonRestart.disabled = false
	
	# Fade down game music (AudioBGM)
	game_music_down()
	
	# MainMenu music sound up
	get_tree().current_scene.get_node("MainMenu").main_menu_music_up()
	
	

func new_game():
	print("new game")
	
	# Kill any mobs
	get_tree().call_group("mobs", "queue_free")
	
#	$HighScores/APHighScores.play("fadeOut")
	scoreActive = true
	score_inc(-score)
#	print("Level: ", $EnemySpawn.lvl)
	$ScoreTimer.start()
	
	# AUDIO
	# Fade down menu music
	get_tree().current_scene.get_node("MainMenu").main_menu_music_down()
	
	# Fade up game music (AudioBGM)
#	audioBGM.volume_db = -15
#	audioBGM.play(0.0)
	game_music_up()
	
	_spawn_player(Vector2(100,300))
	
	# Ready time (links to spawn start)
	$GameWaitTimer.start()
	
	
	
func _spawn_player(pos):
	var player_instance = plPlayer.instance()
	player_instance.global_position = pos
	add_child(player_instance)

func _on_GameWaitTimer_timeout() -> void:
	print("Gamewait timeout")
	levelTimer.start()
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


func game_music_up():
	print("Game music up")
	audioBGM.volume_db = -80
	audioBGM.play(0.0)
	audioBGMTween.interpolate_property(audioBGM, "volume_db", -80, -20, 4.0, 1, Tween.EASE_IN)
	audioBGMTween.start()

func game_music_down():
	audioBGMTween.interpolate_property(audioBGM, "volume_db", -20, -80, 4.0, 1, Tween.EASE_IN)
	audioBGMTween.start()

func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	print("Game tween complete")
	if object.volume_db == 0:
		print("stopping game audio")
		object.stop()
