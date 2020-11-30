extends TextureRect

onready var game = get_tree().current_scene.get_node("Game")

onready var audio = $AudioMainMenu
onready var tweenOut = $AudioMainMenu/TweenOut

func _ready() -> void:
	audio.volume_db = -12
	audio.play()

func _on_New_Game_pressed() -> void:
	$VBoxContainer/ButtonNewGame.disabled = true
	$APMainMenu.play("fadeOut")
	game.new_game()
	yield($APMainMenu, "animation_finished")
	visible = false
	
func main_menu():
	visible = true
	$APMainMenu.play("fadeIn")
	$VBoxContainer/ButtonNewGame.disabled = false
	
func main_menu_music_up():
	audio.volume_db = -80
	audio.play(0.0)
	tweenOut.interpolate_property($AudioMainMenu, "volume_db", -80, -12, 4.0, 1, Tween.EASE_IN)
	tweenOut.start()

func main_menu_music_down():
	tweenOut.interpolate_property($AudioMainMenu, "volume_db", -12, -80, 4.0, 1, Tween.EASE_IN)
	tweenOut.start()


