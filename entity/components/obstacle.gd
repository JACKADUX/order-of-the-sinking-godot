class_name Obstacle extends Component

enum Type {NONE, WALL, GHOST, MOVABLE}
@export var type := Type.NONE

func is_wall() -> bool:
	return type == Type.WALL

func is_ghost() -> bool:
	return type == Type.GHOST

func is_movable() -> bool:
	return type == Type.MOVABLE

func set_type(value:Type):
	set_value("type", value)

func get_data() -> Dictionary:
	return {
		"type": type,
	}
