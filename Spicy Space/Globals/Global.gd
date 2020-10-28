extends Node

#Enums
enum game_mode{start, random, dog_fight, meteor_shower, repairshop, planet}
enum difficulty{null, easy, normal, hard}

#GAME VALUES
var score = 0
var fail_counter = 0
var mine = 0
#ship datas
var ship_datas = {
	durability = 10,
	shield = 5,
	shoot_rate = 0.5,
	laser_damage = 1
}
#repairshop datas
var fully_upg_datas = {
	shoot_fully_upg_control = false
}
var price_datas = {
	price_for_durability = 5,
	price_for_shield = 4,
	price_for_shoot_rate = 6,
	price_for_laser_damage = 7,
	price_for_durability_repair = ship_datas.durability,
	price_for_shield_repair = ship_datas.shield
}

func _ready():
	fail_counter = UserDataManager.load_userdata("fail")
