extends Position2D

# Spawn rate modifiers for progression


var meteor := preload("res://Meteor/Meteor.tscn")
var meteor2 := preload("res://Meteor/Meteor2.tscn")

export var startingSpeed : float = 100.0
export var lvl : int = 1

onready var timer := $EnemyGenerationTimer

signal create_enemy(enemy, location, speed)

var spawnRight := Vector2(1050, rand_range(0, 450))
var spawnTop := Vector2(rand_range(512, 1050), -20)

var spawnAir := [spawnRight, spawnTop]

func _ready() -> void:
	pass

func _on_Player_killed() -> void:
	pass # Replace with function body.


func _on_LevelTimer_timeout() -> void:
	lvl += 1
	print("Level: ", lvl)


func _on_EnemyGenerationTimer_timeout() -> void:
	# Reshuffle all possible positions in all possible sections
	spawnRight = Vector2(1050, rand_range(0, 450))
	spawnTop = Vector2(rand_range(512, 1050), -20)
	
	# Reapply all positions to list of options
	spawnAir = [spawnRight, spawnTop]
	emit_signal("create_enemy", meteor, spawnAir[randi() % len(spawnAir)], 100 * lvl)
