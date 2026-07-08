class_name Enemy extends Entity

func _enter_tree() -> void:
	super()
	add_to_group(Const.GROUP_ENEMY)

func _exit_tree() -> void:
	remove_from_group(Const.GROUP_ENEMY)
	super()
