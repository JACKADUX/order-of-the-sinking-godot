class_name Character extends Entity

@export var active:=true

func _ready() -> void:
	add_to_group(Const.GROUP_CHARACTER)
	var health :Health= get_component(Health)
	if health:
		health.health_changed.connect(func(_v):
			if health.is_dead():
				modulate.a = 0.5
		)

func get_character_index() -> int:
	return get_component(Ability).type
		
func is_active() -> bool:
	var health :Health = get_component(Health)
	if health and health.is_dead():
		return false
	return active

func set_active(value:bool):
	active = value

func is_dead() -> bool:
	return get_component(Health).is_dead()

func get_data() -> Dictionary:
	return super().merged({
		"active":is_active(),
	})

func set_data(data:Dictionary):
	super(data)
	set_active(data.get("active", active))

func handle_event(event:BaseEvent):
	if event is Events.DataChangedEvent:
		if not is_dead():
			modulate.a = 1
