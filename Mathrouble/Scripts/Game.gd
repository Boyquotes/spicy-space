extends Node2D

export (PackedScene) var asteroid
export (bool) var reset_highscore = false

onready var spaceship = $SpaceShip
#Asteroid
onready var asteroid_spawn_loc = $Asteroid/Asteroid_Path/PathFollow2D
onready var asteroid_timer = $Asteroid/Asteroid_Timer
onready var asteroid_con = $Asteroid/Asteroid_Container
#Robots Follow AI
onready var follow_ai = ResourceLoader.load("res://Scenes/RobotFollowAI.tscn")
#Robots
onready var health_robot = ResourceLoader.load("res://Scenes/HealthRobot.tscn")
onready var ammo_robot = ResourceLoader.load("res://Scenes/AmmoRobot.tscn")
#HUD
onready var hud = $HUD

var ins_hr # health robot instance
var ins_ar # ammo robot instance

func _ready():
	#reset highscore
	if reset_highscore == true:
		Global.reset_highscore()
	_robots_activate()
	signal_connect("ss")

func _robots_activate():
	#create follow ai for robots
	var hr_follow_ai = follow_ai.instance()
	var ar_follow_ai = follow_ai.instance()
	add_child(hr_follow_ai)
	add_child(ar_follow_ai)
	hr_follow_ai.global_position = Vector2(spaceship.global_position.x - 15, spaceship.global_position.y - 35)
	ar_follow_ai.global_position = Vector2(spaceship.global_position.x + 5, spaceship.global_position.y - 35)
		
	#create health robot
	ins_hr = health_robot.instance()
	hr_follow_ai.add_child(ins_hr)
	#set location for hr to folllow spaceship
	hr_follow_ai.following_obj = spaceship.hr_followpoint
	hr_follow_ai.target = spaceship.hr_followpoint.global_position

	#create ammo robot
	ins_ar = ammo_robot.instance()
	ar_follow_ai.add_child(ins_ar)
	#set location for hr to folllow spaceship
	ar_follow_ai.following_obj = spaceship.ar_followpoint
	ar_follow_ai.target = spaceship.ar_followpoint.global_position
	
	signal_connect("hr")

func signal_connect(which_obj):
	if which_obj == "ss":
		# game over signal connect
		spaceship.connect("game_over", self, "game_over")
	if which_obj == "hr":
		##spaceship damage signal connect
		spaceship.connect("ss_damage", ins_hr, "damage_happened")
		##spaceship explode signal connect
		ins_hr.connect("ss_explode", spaceship, "ss_explode")

func _on_StartGame_Timer_timeout():
	asteroid_timer.start()

func _on_Asteroid_Timer_timeout():
    # Choose a random location on Path2D.
	asteroid_spawn_loc.set_offset(randi())
    # Create a asteroid instance and add it to the scene.
	var ast = asteroid.instance()
	asteroid_con.add_child(ast)
    # Set the asteroid's position to a random location.
	ast.position = asteroid_spawn_loc.global_position

func game_over():
	hud.game_over()

