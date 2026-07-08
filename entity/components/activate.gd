class_name Activate extends Component

const K_ACTIVATE := "activate"
@export var activate := false

func is_activated() -> bool:
	return activate

func set_activate(value:bool):
	set_value("activate", value)
