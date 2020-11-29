extends TextureRect

onready var game = get_tree().current_scene.get_node("Game")
onready var tweenOut = $AudioMainMenu/TweenOut

func _on_New_Game_pressed() -> void:
	$VBoxContainer/ButtonNewGame.disabled = true
	$APMainMenu.play("fadeOut")
	tweenOut.interpolate_property($AudioMainMenu, "volume_db", -12, -80, 4.0, 1, Tween.EASE_IN)
	tweenOut.start()
	game.new_game()
	yield($APMainMenu, "animation_finished")
	visible = false
	
func main_menu():
	visible = true
	$APMainMenu.play("fadeIn")
	$VBoxContainer/ButtonNewGame.disabled = false
