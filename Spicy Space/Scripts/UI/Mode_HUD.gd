extends Node2D

onready var score_lbl = $Score_lbl
onready var start_lbl = $Start_lbl
onready var over_lbl = $Over_lbl

func _process(delta):
	_update_score()

func _update_score():
	score_lbl.text = "Score: " + str(Global.score)

func presentation(con):
	if con == "started":
		start_lbl.visible = true
		yield(get_tree().create_timer(3), "timeout")
		start_lbl.visible = false
	if con == "completed":
		over_lbl.visible = true
		yield(get_tree().create_timer(3), "timeout")
		over_lbl.visible = false
