extends Node2D

signal closed

func _on_Close_btn_pressed():
	emit_signal("closed")
