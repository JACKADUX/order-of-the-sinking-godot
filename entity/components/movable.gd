class_name Movable extends Component

@export var obstacle := false

func is_movable() -> bool:
	return _entity.visible and not obstacle


func get_data() -> Dictionary:
	return super().merged({
		"obstacle":obstacle
	})
func set_data(data:Dictionary):
	super(data)
	set_obstacle(data.get("obstacle", obstacle))
	
func set_obstacle(value:bool):
	if obstacle == value:
		return 
	obstacle = value
	raise_value_changed("obstacle")
