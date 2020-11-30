extends MarginContainer

onready var labelNames = $ScoreBoard/VBoxContainer/HBoxContainer/LabelNames
onready var labelScores = $ScoreBoard/VBoxContainer/HBoxContainer/LabelScores

onready var buttonRestart = $ScoreBoard/VBoxContainer/HBoxContainer2/ButtonRestartGame
onready var buttonMain = $ScoreBoard/VBoxContainer/HBoxContainer2/ButtonMainMenu
onready var game = get_tree().current_scene.get_node("Game")

var scoreData: Array = [
	1000,
	750,
	600,
	400,
	250,
	0,
]

var nameData: Array = [
	"HTheGreat (Code Guy)",
	"Kenthril (Mr.Artist)",
	"Ioanna (Story Gal)",
	"Juuso (Sound Dude)",
	"tsouthom (Code Guy)",
	"",
]



var board: Array = [nameData, scoreData]
# board = [[name1, ...], [score1, ...]]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Update board
	_updateBoard()
#	# Testing new submission function
#	newAttempt(["big guy", 6666])

# Given the current board, place [attemptName, attemptScore] inside
func newAttempt(attempt):
#	print("Updating board...")
	var names: Array = board[0]
	var attemptName: String = attempt[0]
	
	var scores: Array = board[1]
	var attemptScore : int = attempt[1]
	
	# move from bottom of board up
	for i in range(len(scores)):
#		print(i)
		if attemptScore >= scores[i]:
			names.insert(i, attemptName)
			scores.insert(i, attemptScore)
			names.remove(len(names))
			scores.remove(len(scores))
			
			board = [names, scores]
			_updateBoard()
			break


func _updateBoard():
	var names: String = ""
	var scores: String = ""
	
	for i in range(6):
		# names = board[0]
		names += str(board[0][i]) + "\n"
		# scores = board[1]
		scores += str(board[1][i]) + "\n"
	
	labelNames.set_text(names)
	labelScores.set_text(scores)


func _on_ButtonRestartGame_pressed() -> void:
	buttonRestart.disabled = true
	buttonMain.disabled = true
	$APHighScores.play("fadeOut")
	yield($APHighScores, "animation_finished")
	visible = false
	game.new_game()
	
func game_over():
	$APHighScores.play("fadeIn")
	visible = true
	yield($APHighScores, "animation_finished")
	buttonRestart.disabled = false
	buttonMain.disabled = false


func _on_ButtonMainMenu_pressed() -> void:
	buttonRestart.disabled = true
	buttonMain.disabled = true
	$APHighScores.play("fadeOut")
	get_tree().current_scene.get_node("MainMenu").main_menu()
	yield($APHighScores, "animation_finished")
	visible = false
	
