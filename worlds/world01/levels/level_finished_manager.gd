class_name LevelFinishedManager extends Node

@export var gate_buttons: Array[GateButton] = []

func _ready() -> void:
	for gb in gate_buttons:
		gb.state_changed.connect(check_finished)
			
func check_finished():
	var res = gate_buttons.all(func(gb): return gb.is_active())
	if res:
		pass
