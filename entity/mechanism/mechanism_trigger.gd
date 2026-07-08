@abstract  # 触发器
class_name MechanismTrigger extends Mechanism

func _ready() -> void:
	add_to_group(Const.GROUP_MECHANISM_TRIGGER)
