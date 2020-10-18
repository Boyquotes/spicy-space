extends Node2D

export (bool) var line_activated = false
export (NodePath) var start_road
export (NodePath) var end_road

onready var line = $Line2D
onready var start_road_node = get_node(start_road)
onready var end_road_node = get_node(end_road)

func _ready():
	_check_roads()

func _check_roads():
	if start_road_node.mode_completed && !line_activated:
		_line("activate")
		end_road_node.button.disabled = false
	if !end_road_node.button.disabled && !line_activated:
		start_road_node.button.disabled = true
	if start_road_node.mode_completed && end_road_node.mode_completed:
		_line("completed")

func _line(status):
	if status == "activate":
		line.default_color = Color.white
		line_activated = true
	elif status == "completed":
		line.default_color = Color.aqua

func _on_Road_Line_visibility_changed():
	_check_roads()
