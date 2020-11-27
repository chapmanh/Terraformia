extends Node2D

# Preload any mob scenes which can spawn
var meteor := preload("res://Meteor/Meteor.tscn")
var meteor2 := preload("res://Meteor/Meteor2.tscn")

var enemies := [meteor, meteor2]

onready var enemyGenTimer := $EnemyGenerator/EnemyGenerationTimer
onready var enemyLocation := $EnemyGenerator

# WIP, currently define speed of ALL spawns
# TO DO: Replace speed with speed modifier, pass to all instantiated mobs
# Mobs will therefore be in charge of their own speeds, which are then modded.
export var startingSpeed : float = 100.0

# Init. level info
export var lvl : int = 1
var lvlLength : int = 10


# Init. spawn variable info, and array
var spawnRight := Vector2(1050, rand_range(0, 450))
var spawnTop := Vector2(rand_range(512, 1050), -20)
var spawnAir := [spawnRight, spawnTop]

var spawnGround := Vector2(1050, 550)

func _ready() -> void:
	pass

func _on_LevelTimer_timeout() -> void:
	lvl += 1
	print("Level: ", lvl)

func _on_EnemyGenerationTimer_timeout() -> void:
	
	# Randomise next possible spawn locations, update array
	spawnRight = Vector2(1050, rand_range(0, 450))
	spawnTop = Vector2(rand_range(512, 1050), -20)
	spawnAir = [spawnRight, spawnTop]
	
	# Enemy selection logic (HARD CODED CURRENTLY)
	var enemy
	if randi() % 10 == 0:
		enemy = enemies[1]
	else:
		enemy = enemies[0]
	
	# Create the enemy at a random position from the possible positions
	_create_enemy(enemy, spawnAir[randi() % len(spawnAir)], 100 * lvl)
	
	# Restart EnemyGenerationTimer (currently with default time)
	enemyGenTimer.start()

func _create_enemy(enemy, location, speed) -> void:
	var enemy_instance = enemy.instance()
	enemy_instance.global_position = location
	enemy_instance.speed = speed
	add_child(enemy_instance)
