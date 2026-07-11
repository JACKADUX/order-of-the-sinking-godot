class_name Coords extends Component

const K_DIRECTION := "direction"
const K_COORDS := "coords"

@export var direction := Vector2i.DOWN
@export var coords := Vector2i.ZERO

func get_direction() -> Vector2i:
	return direction

func set_direction(value:Vector2i):
	set_value("direction", value)

func get_coords() -> Vector2i:
	return coords

func set_coords(value:Vector2i):
	set_value("coords", value)
	
func get_data() -> Dictionary:
	return {
		"coords": get_coords()
	}
