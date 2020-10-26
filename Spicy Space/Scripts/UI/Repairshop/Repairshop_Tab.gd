extends Node

signal mine_spend(event)

var repairshop_hud

func get_ship_data(data_key):
	return str(Global.ship_datas.get(data_key))

func get_price_data(data_key):
	return str(Global.price_datas.get(data_key))

