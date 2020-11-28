extends MarginContainer

onready var labelNames = $ScoreBoard/VBoxContainer/HBoxContainer/LabelNames
onready var labelScores = $ScoreBoard/VBoxContainer/HBoxContainer/LabelScores

var scoreData: Array = [
	1000,
	900,
	800,
	700,
	550,
]

var nameData: Array = [
	"Player 1 SUUUUPER LONG NAME TEST",
	"hfudiasfea",
	"dhwuwiadhuwai",
	"babx9oqoa",
	"hgiacjabchfda",
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
	print("Updating board...")
	var names: Array = board[0]
	var attemptName: String = attempt[0]
	
	var scores: Array = board[1]
	var attemptScore : int = attempt[1]
	
	# move from bottom of board up
	for i in range(len(scores)):
		print(i)
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
	
	for i in range(5):
		# names = board[0]
		names += str(board[0][i]) + "\n"
		# scores = board[1]
		scores += str(board[1][i]) + "\n"
	
	labelNames.set_text(names)
	labelScores.set_text(scores)
