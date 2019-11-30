extends Node

const SAVE_FILE_PATH = "user://userdata.save"

var data ={
	highscore = 0,
	bestwave = 0,
	mine = 0
}

func _ready():
	for i in range(data.size()):
		var key = data.keys()[i]
		data[key] = load_userdata(key)

func save_userdata(key, value):
	if key == "highscore" || key == "bestwave":
		if load_userdata(key) > value:
			return

	var save_file = File.new()
	save_file.open(SAVE_FILE_PATH, File.WRITE)
	data[key] = value
	save_file.store_line(to_json(data))
	save_file.close()

func load_userdata(key):
	var save_file = File.new()
	if !save_file.file_exists(SAVE_FILE_PATH):
		return 0

	save_file.open(SAVE_FILE_PATH, File.READ)
	var data  = parse_json(save_file.get_line())
	return data[key]

func reset_userdata():
	var dir = Directory.new()
	dir.remove(SAVE_FILE_PATH)
