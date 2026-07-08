class_name Obstacle extends Component

enum Type {BLOCK, GHOST, MOVABLE}
@export var type := Type.BLOCK

func is_block() -> bool:
	return type == Type.BLOCK

func is_ghost() -> bool:
	return type == Type.GHOST

func is_movable() -> bool:
	return type == Type.MOVABLE

func change_type(value:Type):
	set_value("type", value)
