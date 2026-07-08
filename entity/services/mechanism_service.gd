class_name MechanismService extends Service

var tilemap_manager:TileMapManager
var entity_manager:EntityManager

func _init(_tilemap_manager:TileMapManager, _entity_manager:EntityManager) -> void:
	tilemap_manager = _tilemap_manager
	entity_manager = _entity_manager

func update():
	var alive_enemies_count = entity_manager.get_enemies().size()
	for trigger : MechanismTrigger in entity_manager.get_triggers():
		if trigger is PressurePlate:
			var value = entity_manager.get_entity_at(trigger.get_coords()) != null
			trigger.set_active(value)
		elif trigger is EnemyCounter:
			trigger.set_active(alive_enemies_count == 0)
			
	var entities = entity_manager.get_entites()
	var any_dead := false
	for actuator :MechanismActuator in entity_manager.get_actuators():
		actuator.check_triggers()
		if actuator is Door and not actuator.is_activated():
			var coords = actuator.get_coords()
			for entity :Entity in entities:
				if entity.has_component(Health) and entity.get_coords() == coords:
					entity.get_component(Health).to_death()
					any_dead = true
	if any_dead:
		raise_event(Events.DataChangedEvent.new())
						
