extends "res://Scripts/UI/Repairshop/Repairshop_Tab.gd"

signal repaired(part)

onready var dur_lbl = $Durability/Durability_lbl
onready var dur_btn = $Durability/Durability_btn
onready var shield_lbl = $Shield/Shield_lbl
onready var shield_btn = $Shield/Shield_btn

func _ready():
	repairshop_hud = self.get_parent().get_parent().get_parent()
	_prepare_repair_scene()

func _prepare_repair_scene():
	#Durability
	dur_lbl.text = "Durability: " + str(repairshop_hud.spaceship_mock_info("durability")) + "/" + get_ship_data("durability")
	dur_btn.text = _prepare_repair_btns("price_for_durability_repair")
	_check_repair_btns("price_for_durability_repair")
	#Shield
	shield_lbl.text = "Shield: " + str(repairshop_hud.spaceship_mock_info("shield")) + "/" + get_ship_data("shield")
	shield_btn.text = _prepare_repair_btns("price_for_shield_repair")
	_check_repair_btns("price_for_shield_repair")

func _prepare_repair_btns(data_key):
	return "x " + get_price_data(data_key) + " for Repair"

func _check_repair_btns(data_key):
	var repair_btn = _find_btn(data_key)
	if Global.price_datas.get(data_key) < Global.mine: 
		if _check_repair_need(data_key):
			repair_btn.disabled = false
		else:
			repair_btn.disabled = true
	else:
		repair_btn.disabled = true

#does robots need repair or not?
func _check_repair_need(data_key):
	var need_repair_control
	if data_key == "price_for_durability_repair":
		if repairshop_hud.spaceship_mock_info("durability") == int(get_ship_data("durability")):
			need_repair_control = false
		else:
			need_repair_control = true
	elif data_key == "price_for_shield_repair":
		if repairshop_hud.spaceship_mock_info("shield") == int(get_ship_data("shield")):
			need_repair_control = false
		else:
			need_repair_control = true
	return need_repair_control

func _find_btn(data_key):
	var btn
	if data_key == "price_for_durability_repair":
		btn = dur_btn
	elif data_key == "price_for_shield_repair":
		btn = shield_btn
	return btn

func _on_Durability_btn_pressed():
	_spend_mine("price_for_durability_repair")
	emit_signal("repaired", "durability")
	dur_btn.disabled = !_check_repair_need("price_for_durability_repair")
	_prepare_repair_scene()

func _on_Shield_btn_pressed():
	_spend_mine("price_for_shield_repair")
	emit_signal("repaired", "shield")
	shield_btn.disabled = !_check_repair_need("price_for_shield_repair")
	_prepare_repair_scene()

func _spend_mine(data_key):
	var repair_price = Global.price_datas.get(data_key)
	Global.mine = Global.mine - repair_price
	repairshop_hud.show_mine_value()
	emit_signal("mine_spend", "spend")
	_prepare_repair_scene()

func _on_Repair_HUD_visibility_changed():
	_prepare_repair_scene()

