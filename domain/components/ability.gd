class_name Ability extends Component

enum Type {NONE, POWER, STEAL, TELEPORT, IMMUNITY, FOLLOW, MORPH}
@export var type:Type=Type.NONE  # NOTE: 本质上就是角色的移动方式

func get_type() -> Type:
	return type

func get_data() -> Dictionary:
	return {
		"type": get_type()
	}
