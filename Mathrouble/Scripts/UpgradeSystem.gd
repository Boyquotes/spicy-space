extends Node2D

signal mine_spend(event)
signal upgraded(part)

onready var dur_lbl = $Durability/Durability_lbl
onready var dur_btn = $Durability/Durability_btn
onready var shield_lbl = $Shield/Shield_lbl
onready var shield_btn = $Shield/Shield_btn
onready var shoot_rate_lbl = $Shoot/Shoot_lbl
onready var shoot_rate_btn = $Shoot/Shoot_btn

func _ready():
	_prepare_upg_scene()

func _prepare_upg_scene():
	#Durability
	dur_lbl.text = "Durability: " + _get_data("ship_dur")
	dur_btn.text = _prepare_upg_btns("mine_for_dur_upg")
	_check_upg_btns("mine_for_dur_upg")
	#Shield
	shield_lbl.text = "Shield: " + _get_data("shield")
	shield_btn.text = _prepare_upg_btns("mine_for_shield_upg")
	_check_upg_btns("mine_for_shield_upg")
	#Shoot Rate
	shoot_rate_lbl.text = "Shoot Rate: " + _get_data("shoot_rate")
	shoot_rate_btn.text = _prepare_upg_btns("mine_for_shoot_rate_upg")
	_check_upg_btns("mine_for_shoot_rate_upg")

func _get_data(data_key):
	return str(UserDataManager.load_userdata(data_key))

func _prepare_upg_btns(data_key):
	return "x " + _get_data(data_key) + " for Upgrade"

func _check_upg_btns(data_key):
	var upg_btn = _find_btn(data_key)
	if UserDataManager.load_userdata(data_key) > Global.mine_counter:
		upg_btn.disabled = true
	else:
		upg_btn.disabled = false

func _find_btn(data_key):
	var btn
	if data_key == "mine_for_dur_upg":
		btn = dur_btn
	elif data_key == "mine_for_shield_upg":
		btn = shield_btn
	elif data_key == "mine_for_shoot_rate_upg":
		btn = shoot_rate_btn
	return btn

func _on_Durability_btn_pressed():
	var ship_dur = UserDataManager.load_userdata("ship_dur")
	var new_ship_dur = ship_dur + 25
	UserDataManager.save_userdata("ship_dur", new_ship_dur)
	
	_mine_after_upgrade("mine_for_dur_upg")
	emit_signal("upgraded", "ship_dur")

func _on_Shield_btn_pressed():
	var shield = UserDataManager.load_userdata("shield")
	var new_shield = shield + 10
	UserDataManager.save_userdata("shield", new_shield)
	
	_mine_after_upgrade("mine_for_shield_upg")
	emit_signal("upgraded", "shield")

func _on_Shoot_btn_pressed():
	var shoot_rate = UserDataManager.load_userdata("shoot_rate")
	var new_shoot_rate
	if shoot_rate > 0.3:
		new_shoot_rate = shoot_rate - 0.05
	elif shoot_rate > 0.1 && shoot_rate <= 0.3:
		new_shoot_rate = shoot_rate - 0.03
	elif shoot_rate <= 0.1 && shoot_rate >= 0.06:
		new_shoot_rate = shoot_rate - 0.01
		if shoot_rate == 0.06:
			print("fully upgraded")
	UserDataManager.save_userdata("shoot_rate", new_shoot_rate)
	
	_mine_after_upgrade("mine_for_shoot_rate_upg")
	emit_signal("upgraded", "shoot_rate")

func _mine_after_upgrade(data_key):
	var upg_mine_value = UserDataManager.load_userdata(data_key)
	Global.mine_counter = Global.mine_counter - upg_mine_value
	emit_signal("mine_spend", "spend")

	var new_upg_mine_value = upg_mine_value + (upg_mine_value * 0.5)
	UserDataManager.save_userdata(data_key, int(new_upg_mine_value))
	
	_prepare_upg_scene()

func _on_Upgrade_HUD_visibility_changed():
	_prepare_upg_scene()
