extends "res://Scripts/Game_Modes/Game_Mode.gd"

export (Array, PackedScene) var enemies
export (bool) var reset_userdata = false

#Pitfalls
onready var pitfalls_spawn_loc = $Pitfalls/Pitfalls_Path/PathFollow2D
#Enemy
onready var enemy_con = $Pitfalls/Enemy/Enemy_Container

var ins_enemy # enemy instance
var mode_control = false #check out dog fight happened or not
var border_of_enemy = 1
var enemy_counter = 0

func _ready():
	#get number of enemy
	border_of_enemy = UserDataManager.load_userdata("number_of_enemy")

func _process(delta):
	if mode_control:
		_dog_fight("checkout")

func _on_StartMode_Timer_timeout():
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
		spaceship.shoot_control = true
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
			spaceship.shoot_control = false

