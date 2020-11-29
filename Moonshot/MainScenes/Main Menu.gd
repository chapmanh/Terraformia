extends TextureRect

onready var game = get_tree().current_scene.get_node("Game")

func _on_New_Game_pressed() -> void:
	$VBoxContainer/ButtonNewGame.disabled = true
	$APMainMenu.play("fadeOut")
	game.new_game()
	yield($APMainMenu, "animation_finished")
	visible = false
