extends Node

#GAME VALUES
var score = 0
var wave = 0
var mine_counter = 0

func _ready():
	mine_counter = UserDataManager.load_userdata("mine")
