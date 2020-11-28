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
	var names: String = ""
	var scores: String = ""
	
	for i in range(len(scoreData)):
		# names = board[0]
		names += str(board[0][i]) + "\n"
		# scores = board[1]
		scores += str(board[1][i]) + "\n"
	
	labelNames.set_text(names)
	labelScores.set_text(scores)

# Given the current board, place attempt [attemptName, attemptScore] inside
func _updateBoard(board, attempt):
	pass
	
