extends Control


onready var score_label = $MarginContainer/HBoxContainer/ScoreLabel
func _ready():
    update_score()


func update_score():
    score_label.set_text(str(G.score))
