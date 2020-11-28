extends MarginContainer

onready var labelNames = $ScoreBoard/VBoxContainer/HBoxContainer/LabelNames
onready var labelScores = $ScoreBoard/VBoxContainer/HBoxContainer/LabelScores

var scoreData = {
	"Player 1 SUUUUPER LONG NAME TEST" : 1000,
	"hfudiasfea" : 900,
	"dhwuwiadhuwai" : 800,
	"babx9oqoa": 700,
	"hgiacjabchfda": 550,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var names: String = ""
	var scores: String = ""
	
	for name in scoreData:
		names += str(name) + "\n"
		scores += str(scoreData[name]) + "\n"
	
	labelNames.set_text(names)
	labelScores.set_text(scores)
