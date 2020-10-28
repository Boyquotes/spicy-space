extends Node2D

signal closed

onready var mine_lbl = $Mine_Info/Mine_lbl
#onready var spaceship_mock = $Spaceship_Mock

var spaceship_mock

func _ready():
	get_parent().emit_signal("send_robot_info")
	show_mine_value()

func show_mine_value():
	mine_lbl.text = "x " + str(Global.mine)

func spaceship_mock_info(robot):
	spaceship_mock = $Spaceship_Mock
	return spaceship_mock.get_robot_info(robot)

func _on_Close_btn_pressed():
	SFXManager.button.play()
	emit_signal("closed")
