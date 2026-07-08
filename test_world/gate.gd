class_name Gate extends Node2D

signal state_changed()

@onready var sprite_2d: Sprite2D = %Sprite2D

@export var gate_buttons:Array[GateButton] = []

var active := false

func _ready() -> void:
	add_to_group(Const.GROUP_GATE)
	for child in get_children():
		if child is GateButton and child not in gate_buttons:
			gate_buttons.append(child)
	for gb in gate_buttons:
		gb.state_changed.connect(check_active)
	
func check_active():
	var prv = active
	active = gate_buttons.all(func(gb): return gb.is_active())
	sprite_2d.texture.x = 1 if active else 0
	if prv != active:
		if active:
			remove_from_group(Const.GROUP_GATE)
		else:
			add_to_group(Const.GROUP_GATE)
		state_changed.emit()
