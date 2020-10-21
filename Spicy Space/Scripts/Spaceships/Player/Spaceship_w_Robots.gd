extends Node2D

onready var spaceship = $SpaceShip
#Robots Follow AI
onready var follow_ai = ResourceLoader.load("res://Scenes/Spaceship_,Parts/Robots/RobotFollowAI.tscn")
#Robots
onready var health_robot = ResourceLoader.load("res://Scenes/Spaceship_,Parts/Robots/HealthRobot.tscn")
onready var shield_robot = ResourceLoader.load("res://Scenes/Spaceship_,Parts/Robots/ShieldRobot.tscn")

var ins_hr # health robot instance
var ins_sr # shield robot instance

func _ready():
	_activate_robots()
	_signal_connect()

func _activate_robots():
	#create follow ai for robots
	var hr_follow_ai = follow_ai.instance()
	var sr_follow_ai = follow_ai.instance()
	add_child(hr_follow_ai)
	add_child(sr_follow_ai)
	hr_follow_ai.global_position = Vector2(spaceship.global_position.x - 15, spaceship.global_position.y - 35)
	sr_follow_ai.global_position = Vector2(spaceship.global_position.x + 5, spaceship.global_position.y - 35)

	#create health robot
	ins_hr = health_robot.instance()
	hr_follow_ai.add_child(ins_hr)
	#set location for hr to folllow spaceship
	hr_follow_ai.following_obj = spaceship.hr_followpoint
	hr_follow_ai.target = spaceship.hr_followpoint.global_position

	#create shield robot
	ins_sr = shield_robot.instance()
	sr_follow_ai.add_child(ins_sr)
	#set location for sr to follow spaceship
	sr_follow_ai.following_obj = spaceship.sr_followpoint
	sr_follow_ai.target = spaceship.sr_followpoint.global_position
	
	# add robots to the spaceship
	spaceship.robots.append(ins_hr)
	spaceship.robots.append(ins_sr)

#signal connects between spaceship and robots
func _signal_connect():
	#when spaceship grabbed crate signal connect
	spaceship.connect("crate_grabbed", ins_hr, "robot_charge")
	spaceship.connect("crate_grabbed", ins_sr, "robot_charge")
	#health robot situation signal control
	spaceship.connect("hr_situation", ins_hr, "hr_situation")
	#spaceship damage signal connect
	spaceship.connect("ss_damage", ins_hr, "damage_happened")
	#spaceship explode signal connect
	ins_hr.connect("ss_explode", spaceship, "ss_explode")
	#spaceship damage signal connect
	spaceship.connect("ss_damage", ins_sr, "damage_happened")
	#change health robot situation according to shield robot situation signal connect
	ins_sr.connect("sr_deactivated", ins_hr, "hr_situation")
	#change shield situation according to shield robot situation signal connect
	ins_sr.connect("sr_deactivated", spaceship, "ss_shield_deactivate")

