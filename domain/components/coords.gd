class_name Transform extends Component

const K_DIRECTION := "direction"
const K_COORDS := "coords"
const K_ZDEPTH := "zdepth"

@export var direction := Vector2i.RIGHT
@export var coords := Vector2i.ZERO
@export var zdepth := 0

func get_direction() -> Vector2i:
	return direction

func set_direction(value:Vector2i):
	set_value(K_DIRECTION, value)

func get_coords() -> Vector2i:
	return coords

func set_coords(value:Vector2i):
	set_value(K_COORDS, value)

func get_zdepth() -> int:
	return zdepth

func set_zdepth(value:int):
	set_value(K_ZDEPTH, value)

func get_data() -> Dictionary:
	return {
		K_COORDS: get_coords(),
		K_DIRECTION: get_direction(),
		K_ZDEPTH: get_zdepth(),
	}
