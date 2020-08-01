extends Node

#GAME VALUES
var score = 0
var wave = 0
var mine_counter = 0
var fail_counter = 0

func _ready():
	wave = int(UserDataManager.load_userdata("current_wave"))
	mine_counter = UserDataManager.load_userdata("mine")
	fail_counter = UserDataManager.load_userdata("fail")
