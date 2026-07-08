@abstract  # 执行器
class_name MechanismActuator extends Mechanism  

func _ready() -> void:
	add_to_group(Const.GROUP_MECHANISM_ACTUATOR)

func check_triggers():
	pass
