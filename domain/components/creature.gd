class_name Creature extends Component

@export var crystalize := false

func is_crystalized() -> bool:
	return crystalize

func set_crystalize(value:bool):
	set_value("crystalize", value)

func get_data() -> Dictionary:
	return {
		"crystalize": is_crystalized()
	}
