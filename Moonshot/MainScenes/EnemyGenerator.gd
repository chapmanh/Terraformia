extends Position2D

# Spawn rate modifiers for progression


var meteor := preload("res://Meteor/Meteor.tscn")
var meteor2 := preload("res://Meteor/Meteor2.tscn")

onready var timer := $Timer

signal create_enemy(enemy, location)

var spawnRight := Vector2(1050, rand_range(0, 450))
var spawnTop := Vector2(rand_range(512, 1050), -20)

var spawnAir := [spawnRight, spawnTop]

func _ready() -> void:
	pass

func _on_Timer_timeout() -> void:
	emit_signal("create_enemy", meteor, spawnAir[randi() % len(spawnAir)])


func _on_Player_killed() -> void:
	pass # Replace with function body.
