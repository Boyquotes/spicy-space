extends Node2D

export (PackedScene) var asteroid
export (bool) var reset_highscore = false

onready var spaceship = $SpaceShip
#Asteroid
onready var asteroid_spawn_loc = $Asteroid/Asteroid_Path/PathFollow2D
onready var asteroid_timer = $Asteroid/Asteroid_Timer
onready var asteroid_con = $Asteroid/Asteroid_Container
#HUD
onready var hud = $HUD
#Robots Follow AI
onready var follow_ai = ResourceLoader.load("res://Scenes/RobotFollowAI.tscn")
#Robots
onready var health_robot = ResourceLoader.load("res://Scenes/HealthRobot.tscn")
onready var ammo_robot = ResourceLoader.load("res://Scenes/AmmoRobot.tscn")
#Crate
onready var crate_con = $Crate_Container
onready var crate = ResourceLoader.load("res://Scenes/Crate.tscn")

var ins_hr # health robot instance
var ins_ar # ammo robot instance
var ins_ast # asteroid instance

func _ready():
	#reset highscore
	if reset_highscore == true:
		Global.reset_highscore()
	#reset score after every new start
	Global.score = 0

	_robots_activate()
	_signal_connect("ss")

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
	
	# add robots to the spaceship
	spaceship.robots.append(ins_hr)
	spaceship.robots.append(ins_ar)
	
	_signal_connect("hr")
	_signal_connect("ar")

func _signal_connect(which_obj):
	if which_obj == "ss": #space ship
		# game over signal connect
		spaceship.connect("game_over", self, "game_over")
		#when spaceship grabbed crate signal connect
		spaceship.connect("crate_grabbed", ins_hr, "robot_charge")
		spaceship.connect("crate_grabbed", ins_ar, "robot_charge")
	if which_obj == "hr": #health robot
		##spaceship damage signal connect
		spaceship.connect("ss_damage", ins_hr, "damage_happened")
		##spaceship explode signal connect
		ins_hr.connect("ss_explode", spaceship, "ss_explode")
	if which_obj == "ar": #ammo robot
		#reduce ammo when laser shooted signal connect
		spaceship.connect("shoot", ins_ar, "laser_shooted")
		#check out ammo fignal connect
		ins_ar.connect("out_of_ammo", spaceship, "out_of_ammo_control")
	if which_obj == "ast":
		#signal to crate control after asteroid exploded
		ins_ast.connect("ast_exploded", self, "crate_control")

func _on_StartGame_Timer_timeout():
	asteroid_timer.start()

func _on_Asteroid_Timer_timeout():
    # Choose a random location on Path2D.
	asteroid_spawn_loc.set_offset(randi())
    # Create a asteroid instance and add it to the scene.
	ins_ast = asteroid.instance()
	asteroid_con.add_child(ins_ast)
    # Set the asteroid's position to a random location.
	ins_ast.position = asteroid_spawn_loc.global_position

	_signal_connect("ast")

func crate_control(pos):
	var crate_chance = rand_range(0, 100)
	if crate_chance < 25:
		var ins_crate = crate.instance()
		crate_con.call_deferred("add_child", ins_crate) # !flushed_queries error fixed with this line
		ins_crate.position = pos
	#	print(pos)
	else:
		pass

func game_over():
	hud.game_over()

