extends Node2D

onready var enemyGenTimer := $EnemyGenerator/EnemyGenerationTimer
onready var enemyLocation := $EnemyGenerator

var lvlLength : int = 10

func _ready() -> void:
	enemyGenTimer.connect("timeout", self, "_on_EnemyGenerationTimer_timeout")

func _on_EnemyGenerator_create_enemy(enemy, location, speed) -> void:
	var enemy_instance = enemy.instance()
	enemy_instance.global_position = location
	enemy_instance.speed = speed
	add_child(enemy_instance)	

func _on_EnemyGenerationTimer_timeout():
	# Allows for more sporadic spawning in future
	enemyGenTimer.start()

func _on_Player_killed() -> void:
	pass # Replace with function body.
