class_name Obstacle extends Component

enum Type {NONE, WALL, GHOST, MOVABLE}
@export var type := Type.NONE
@export var supportable := false  # NOTE: 晶体在水里

func is_wall() -> bool:
	return type == Type.WALL

func is_ghost() -> bool:
	return type == Type.GHOST

func is_movable() -> bool:
	return type == Type.MOVABLE

func is_supportable()->bool:
	return supportable

func set_supportable(value:bool):
	set_value("supportable", value)

func set_type(value:Type):
	set_value("type", value)

func get_type() -> Type:
	return type

func get_data() -> Dictionary:
	return {
		"type": type,
		"supportable": is_supportable(),
	}
