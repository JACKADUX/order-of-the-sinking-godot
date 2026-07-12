@abstract  # 触发器
class_name MechanismTrigger extends Entity

func _ready() -> void:
	add_to_group(Const.GROUP_MECHANISM_TRIGGER)

func is_activated() -> bool:
	return get_component(Activate).is_activated()

func check_mechanism(service:MechanismService):
	pass
