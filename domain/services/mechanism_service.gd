class_name MechanismService extends Service

var entity_manager:EntityManager
var tilemap_manager:TileMapManager

func _init(app:Application) -> void:
	entity_manager = app.get_manager(EntityManager)
	tilemap_manager = app.get_manager(TileMapManager)

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
	
