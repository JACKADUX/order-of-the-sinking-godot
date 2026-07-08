@abstract 
class_name Mechanism extends Entity

signal active_state_changed

var activated := false

func is_activated() -> bool:
	return activated

func set_active(value:bool):
	if value == activated:
		return 
	activated = value
	update()
	active_state_changed.emit()

func update():
	pass
