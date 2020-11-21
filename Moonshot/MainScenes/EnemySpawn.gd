extends Node2D



func _on_EnemyGenerator_create_enemy(enemy, location) -> void:
	var enemy_instance = enemy.instance()
	enemy_instance.global_position = location
	add_child(enemy_instance)
