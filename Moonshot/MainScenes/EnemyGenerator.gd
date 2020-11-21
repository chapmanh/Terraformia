extends Position2D

var meteor := preload("res://Meteor/Meteor.tscn")

signal create_enemy(enemy, location)

var spawnRight := Vector2(1050, rand_range(0, 450))
var spawnTop := Vector2(rand_range(512, 1050), -20)

var spawnAir := [spawnRight, spawnTop]

func _ready() -> void:
	randomize()

func _on_Timer_timeout() -> void:
	emit_signal("create_enemy", meteor, spawnAir[randi() % len(spawnAir)])
