extends Node2D

export(String, "Meteor Shower", "Dog Fight", "Random") var game_mode
export (Array, PackedScene) var enemies
export (bool) var reset_userdata = false

#Game
onready var screen_shake = $Camera2D/ScreenShake
#Spaceship
onready var spaceship = $SpaceShip
#Pitfalls
onready var pitfalls_spawn_loc = $Pitfalls/Pitfalls_Path/PathFollow2D
#Enemy
onready var enemy_con = $Pitfalls/Enemy/Enemy_Container
#HUD
onready var hud = $HUD
#Uograde HUD
onready var upg_hud = $HUD/Upgrade_HUD
#Robots Follow AI
onready var follow_ai = ResourceLoader.load("res://Scenes/RobotFollowAI.tscn")
#Robots
onready var health_robot = ResourceLoader.load("res://Scenes/Robots/HealthRobot.tscn")
onready var shield_robot = ResourceLoader.load("res://Scenes/Robots/ShieldRobot.tscn")
#Crate
onready var crate_con = $Crate_Container
onready var crate = ResourceLoader.load("res://Scenes/Crate.tscn")
#Mine
onready var mine_con = $Mine_Container
onready var mine = ResourceLoader.load("res://Scenes/Mine.tscn")

var ins_hr # health robot instance
var ins_ar # ammo robot instance
var ins_sr # shield robot instance
var ins_enemy # enemy instance
var df_control = false #check out dog fight happened or not
var border_of_enemy = 1
var enemy_counter = 0

func _ready():
	#reset highscore
	if reset_userdata == true:
		UserDataManager.reset_userdata()
	#reset score after every new start
	Global.score = 0
	#get number of enemy
	border_of_enemy = UserDataManager.load_userdata("number_of_enemy")
	
	_robots_activate()
	_signal_connect("ss")
	_signal_connect("upg_sys")

func _process(delta):
	if df_control:
		_dog_fight("checkout")
	#automatic shoot system for spaceship
	if df_control:
		_ss_shoot_system(true)
	else:
		_ss_shoot_system(false)

func _robots_activate():
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
	
	_signal_connect("hr")
	_signal_connect("sr")

func _signal_connect(which_obj):
	if which_obj == "ss": #space ship
		# game over signal connect
		spaceship.connect("game_over", self, "game_over")
		#when spaceship grabbed crate signal connect
		spaceship.connect("crate_grabbed", ins_hr, "robot_charge")
		spaceship.connect("crate_grabbed", ins_sr, "robot_charge")
		#warning signal
		spaceship.connect("warning", hud, "warning")
		#screen shake signal connect
		spaceship.connect("ss_damage", self, "screen_shake")
		#health robot situation signal control
		spaceship.connect("hr_situation", ins_hr, "hr_situation")
		#when spaceship grabbed mine signal connect
		spaceship.connect("mine_grabbed", self, "mine_system")
	if which_obj == "hr": #health robot
		#spaceship damage signal connect
		spaceship.connect("ss_damage", ins_hr, "damage_happened")
		#spaceship explode signal connect
		ins_hr.connect("ss_explode", spaceship, "ss_explode")
	if which_obj == "sr": #shield robot
		#spaceship damage signal connect
		spaceship.connect("ss_damage", ins_sr, "damage_happened")
		#change health robot situation according to shield robot situation signal connect
		ins_sr.connect("sr_deactivated", ins_hr, "hr_situation")
		#change shield situation according to shield robot situation signal connect
		ins_sr.connect("sr_deactivated", spaceship, "ss_shield_deactivate")
	if which_obj == "upg_sys":
		#signal to update mine after spend or collect it
		upg_hud.connect("mine_spend", self, "mine_system")
		#signal to upgrade ship part
		upg_hud.connect("upgraded", self, "upgrade_system")

func _on_StartGame_Timer_timeout():
	yield(get_tree().create_timer(1), "timeout")
	hud.presentation("dog_fight", "started")
	yield(get_tree().create_timer(5), "timeout")
	_enemies("instance")

func _enemies(con):
	if con == "instance":
		# Choose a random location on Path2D.
		pitfalls_spawn_loc.set_offset(randi())
		# Create a enemy instance and add it to the scene.
		ins_enemy = enemies[randi() % enemies.size()].instance() #choose an enemy and instance it
		enemy_con.add_child(ins_enemy)
		enemy_counter += 1
		# Set the asteroid's position to a random location.
		ins_enemy.position = pitfalls_spawn_loc.global_position
		#assign spaceship as target
		ins_enemy.target_obj = spaceship
		#start dog fight
		_dog_fight("start")

func _dog_fight(con):
	if con == "start":
		while (enemy_counter < border_of_enemy):
			_enemies("instance")
		df_control = true #dog fight happen

	if con == "checkout":
		if df_control && enemy_con.get_child_count() == 0:
			df_control = false #dog fight over
			enemy_counter = 0 #reset enemy counter
			
			randomize()
			var noe_possibility = rand_range(0, 90) #number of enemy possibility
#			print(noe_possibility)
			if noe_possibility <= 45:
				border_of_enemy += 1 #increase enemy number for present dog fight
			elif noe_possibility > 45 && noe_possibility <= 75:
				border_of_enemy += 0 #don't change enemy number for present dog fight
			elif noe_possibility > 75:
				if border_of_enemy > 3: #when number of enemy at least 4
					border_of_enemy -= 1 #reduce enemy number for present dog fight
				else:
					border_of_enemy -= 0 #don't change enemy number for present dog fight
#			print(border_of_enemy)
			UserDataManager.save_userdata("number_of_enemy", border_of_enemy)
			hud.presentation("dog_fight", "completed")

func mine_system(con):
	if con == "collect":
		var collected_mine = int(rand_range(Global.wave * 2, Global.wave * 3))
#		print(collected_mine)
		Global.mine_counter += collected_mine
	if con == "spend":
		pass
	if con == "game_over":
		Global.mine_counter -= int(Global.mine_counter * 0.3)
	#save and show mine value
	UserDataManager.save_userdata("mine", Global.mine_counter)
	hud.show_mine_value()

func upgrade_system(part):
	if part == "ship_dur":
		ins_hr.reload_robot(part)
	if part == "shield":
		ins_sr.reload_robot(part)
	if part == "shoot_rate":
		spaceship.reload_spaceship()

func _ss_shoot_system(con): #spaceship shoot system
	spaceship.shoot_control = con

func screen_shake(which_pitfall):
	screen_shake.start(0.2, 15, 16, 1)

func game_over():
	Global.fail_counter += 1
	mine_system("game_over")
	hud.game_over()

