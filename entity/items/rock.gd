class_name Rock extends Entity

# NOTE: 石头会被机关打碎所以有health

func _ready() -> void:
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
		if not is_dead():
			modulate.a = 1
