extends Node2D

signal closed

onready var mine_lbl = $Mine_HUD/Mine_lbl

func _ready():
	show_mine_value()

func show_mine_value():
	mine_lbl.text = "x " + str(Global.mine)

func _on_Close_btn_pressed():
	emit_signal("closed")
