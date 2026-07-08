class_name Enemy extends Entity

func _ready() -> void:
	add_to_group(Const.GROUP_ENEMY)
	var health :Health= get_component(Health)
	if health:
		health.health_changed.connect(func(_v):
			if health.is_dead():
				modulate.a = 0.5
		)

func is_dead() -> bool:
	return get_component(Health).is_dead()

func handle_event(event:BaseEvent):
	if event is Events.DataChangedEvent:
		var health :Health = get_component(Health)
		if not health.is_dead():
			modulate.a = 1
