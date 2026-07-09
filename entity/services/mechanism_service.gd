class_name MechanismService extends Service

var tilemap_manager:TileMapManager
var entity_manager:EntityManager

func _init(_tilemap_manager:TileMapManager, _entity_manager:EntityManager) -> void:
	tilemap_manager = _tilemap_manager
	entity_manager = _entity_manager

func update():
	trigger_check()
	actuator_check()
	door_smash_check()
						
func trigger_check():
	for trigger : MechanismTrigger in entity_manager.get_triggers():
		trigger.check(entity_manager)

func actuator_check():
	for actuator :MechanismActuator in entity_manager.get_actuators():
		actuator.check()
		
func door_smash_check():
	var coords_data = entity_manager.query_coords_entity_data(EntityManager.K_CACHE_ALL)
	var any_dead := false
	var is_character := false
	for actuator :MechanismActuator in entity_manager.get_actuators():
		if actuator is Door and not actuator.is_activated():
			var entity :Entity = coords_data.get(actuator.get_coords())
			if entity:
				var health = entity.get_component(Health)
				if health:
					health.to_death()
					any_dead = true
					if entity is Character:
						is_character = true
	if not any_dead:
		return 
	if is_character:
		raise_event(Events.CharacterDeadEvent.new())
	raise_event(Events.DataChangedEvent.new())
	
