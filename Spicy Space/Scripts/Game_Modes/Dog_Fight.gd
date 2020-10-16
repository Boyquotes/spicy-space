extends Node2D

export(String, "Meteor Shower", "Dog Fight", "Random") var game_mode
export (Array, PackedScene) var enemies
export (bool) var reset_userdata = false

#Game
onready var screen_shake = $Camera2D/ScreenShake
#Spaceship
onready var spaceship_w_robots = $Spaceship_w_Robots
onready var spaceship = $Spaceship_w_Robots/SpaceShip
#Pitfalls
onready var pitfalls_spawn_loc = $Pitfalls/Pitfalls_Path/PathFollow2D
#Enemy
onready var enemy_con = $Pitfalls/Enemy/Enemy_Container
#HUD
onready var hud = $HUD
#Upgrade HUD
onready var upg_hud = $HUD/Upgrade_HUD
#Crate
onready var crate_con = $Crate_Container
onready var crate = ResourceLoader.load("res://Scenes/Crate.tscn")
#Mine
onready var mine_con = $Mine_Container
onready var mine = ResourceLoader.load("res://Scenes/Mine.tscn")

var ins_enemy # enemy instance
var mode_control = false #check out dog fight happened or not
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
	
	_signal_connect("ss")
	_signal_connect("upg_sys")

func _process(delta):
	if mode_control:
		_dog_fight("checkout")
	#automatic shoot system for spaceship
	if mode_control:
		_ss_shoot_system(true)
	else:
		_ss_shoot_system(false)

func _signal_connect(which_obj):
	if which_obj == "ss": #space ship
		# game over signal connect
		spaceship.connect("game_over", self, "game_over")
		#warning signal
		spaceship.connect("warning", hud, "warning")
		#screen shake signal connect
		spaceship.connect("ss_damage", self, "screen_shake")
		#when spaceship grabbed mine signal connect
		spaceship.connect("mine_grabbed", self, "mine_system")
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
		mode_control = true #dog fight happen

	if con == "checkout":
		if mode_control && enemy_con.get_child_count() == 0:
			mode_control = false #dog fight over
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
		spaceship_w_robots.ins_hr.reload_robot(part)
	if part == "shield":
		spaceship_w_robots.ins_sr.reload_robot(part)
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

