extends Node2D

signal activate_roadmap

onready var durability_lbl = $Durability_lbl
onready var shield_lbl = $Shield_lbl
onready var shoot_rate_lbl = $Shoot_rate_lbl
onready var roadmap_btn = $Roadmap_btn

func _process(delta):
	_get_spaceship_infos()

func show_cockpit(status):
	self.visible = status

func roadmap_btn_state(status):
	roadmap_btn.disabled = !status

func _get_spaceship_infos():
	durability_lbl.text = "Durability: "+ str(get_parent().ins_hr.value)+ "/"+ str(Global.ship_datas.get("durability"))
	shield_lbl.text = "Sheild: "+ str(get_parent().ins_sr.value)+ "/"+ str(Global.ship_datas.get("shield"))
	shoot_rate_lbl.text = "Shoot Rate: "+ str(Global.ship_datas.get("shoot_rate"))

func _on_Roadmap_btn_pressed():
	emit_signal("activate_roadmap")
	roadmap_btn_state(false)
