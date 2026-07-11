@abstract  # 执行器
class_name MechanismActuator extends Entity  

func _enter_tree() -> void:
	super()
	add_to_group(Const.GROUP_MECHANISM_ACTUATOR)

func is_activated() -> bool:
	return get_component(Activate).is_activated()

func check():
	pass
