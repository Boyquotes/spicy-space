extends "res://Scripts/UI/Repairshop/Repairshop_Tab.gd"

signal upgraded(part)

onready var dur_lbl = $Durability/Durability_lbl
onready var dur_btn = $Durability/Durability_btn
onready var shoot_rate_lbl = $Shoot/Shoot_lbl
onready var shoot_rate_btn = $Shoot/Shoot_btn
onready var shoot_fully_upg_lbl = $Shoot/fully_upgraded_lbl
onready var laser_lbl = $Laser/Laser_lbl
onready var laser_btn = $Laser/Laser_btn
onready var shield_lbl = $Shield/Shield_lbl
onready var shield_btn = $Shield/Shield_btn

var shoot_fully_upg_control = false

func _ready():
	repairshop_hud = self.get_parent().get_parent().get_parent()
	_prepare_upg_scene()

func _prepare_upg_scene():
	#Durability
	dur_lbl.text = "Durability: " + get_ship_data("durability")
	dur_btn.text = _prepare_upg_btns("price_for_durability")
	_check_upg_btns("price_for_durability")
	#Shoot Rate
	shoot_rate_lbl.text = "Shoot Rate: " + get_ship_data("shoot_rate")
	shoot_rate_btn.text = _prepare_upg_btns("price_for_shoot_rate")
	_check_upg_btns("price_for_shoot_rate")
	if Global.fully_upg_datas.get("shoot_fully_upg_control"):
		shoot_rate_btn.visible = false
		shoot_fully_upg_lbl.visible = true
	#Laser Damage
	laser_lbl.text = "Laser Damage: " + get_ship_data("laser_damage")
	laser_btn.text = _prepare_upg_btns("price_for_laser_damage")
	_check_upg_btns("price_for_laser_damage")
	#Shield
	shield_lbl.text = "Shield: " + get_ship_data("shield")
	shield_btn.text = _prepare_upg_btns("price_for_shield")
	_check_upg_btns("price_for_shield")

func _prepare_upg_btns(data_key):
	return "x " + get_price_data(data_key) + " for Upgrade"

func _check_upg_btns(data_key):
	var upg_btn = _find_btn(data_key)
	if Global.price_datas.get(data_key) > Global.mine:
		upg_btn.disabled = true
	else:
		upg_btn.disabled = false

func _find_btn(data_key):
	var btn
	if data_key == "price_for_durability":
		btn = dur_btn
	elif data_key == "price_for_shoot_rate":
		btn = shoot_rate_btn
	elif data_key == "price_for_laser_damage":
		btn = laser_btn
	elif data_key == "price_for_shield":
		btn = shield_btn
	return btn

func _on_Durability_btn_pressed():
	SFXManager.button.play()
	Global.ship_datas["durability"] += 1
	Global.price_datas["price_for_durability_repair"] += 1
	_spend_mine("price_for_durability")
	emit_signal("upgraded", "durability")

func _on_Shoot_btn_pressed():
	SFXManager.button.play()
	var shoot_rate = Global.ship_datas.get("shoot_rate")
	var new_shoot_rate = shoot_rate - 0.08
	if new_shoot_rate <= 0.15:
		print("shoot rate fully upgraded")
		Global.fully_upg_datas["shoot_fully_upg_control"] = true
		shoot_rate_btn.visible = false
		shoot_fully_upg_lbl.visible = true
	#assign new shoot rate
	Global.ship_datas["shoot_rate"] = new_shoot_rate
	_spend_mine("price_for_shoot_rate")
	emit_signal("upgraded", "shoot_rate")

func _on_Laser_btn_pressed():
	SFXManager.button.play()
	Global.ship_datas["laser_damage"] += 1
	_spend_mine("price_for_laser_damage")
	emit_signal("upgraded", "laser_damage")

func _on_Shield_btn_pressed():
	SFXManager.button.play()
	Global.ship_datas["shield"] += 1
	Global.price_datas["price_for_shield_repair"] += 1
	_spend_mine("price_for_shield")
	emit_signal("upgraded", "shield")

func _spend_mine(data_key):
	var upg_price = Global.price_datas.get(data_key)
	Global.mine = Global.mine - upg_price
	repairshop_hud.show_mine_value()
	emit_signal("mine_spend", "spend")
	_calc_new_price(data_key, upg_price)
	_prepare_upg_scene()

func _calc_new_price(data_key, old_price):
	var new_upg_price = old_price + (old_price * 0.3)
	Global.price_datas[data_key] = int(new_upg_price)

func _on_Upgrade_HUD_visibility_changed():
	_prepare_upg_scene()

