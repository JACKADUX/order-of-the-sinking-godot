class_name GateButton extends Node2D

signal state_changed()

@onready var sprite_2d: Sprite2D = %Sprite2D
var active := false

func _ready() -> void:
	check_active()


func is_active() -> bool:
	return active
	
func something_happened():
	check_active()
	
func check_active():
	var prv = active
	active = has_any_on_top()
	sprite_2d.texture.x = 1 if active else 0
	if prv != active:
		state_changed.emit()
	
func has_any_on_top()->bool:
	var coords = Const.get_coords(global_position)
	for item in Const.get_every_thing():
		if coords == Const.get_coords(item.global_position):
			return true
	return false
