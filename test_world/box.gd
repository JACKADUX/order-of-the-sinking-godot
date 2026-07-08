class_name Box extends Node2D

func _ready() -> void:
	add_to_group(Const.GROUP_BOX)

func get_data() -> Dictionary:
	return {
		"id":get_instance_id(),
		"global_position":global_position,
	}
func set_data(data:Dictionary):
	global_position = data.get("global_position", global_position)
