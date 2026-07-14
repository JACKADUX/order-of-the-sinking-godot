class_name MechanismService extends Service

func update():
	trigger_check()
	actuator_check()
	door_smash_check()
	level_finish_check()
	
func trigger_check():
	for trigger : MechanismTrigger in entity_manager.get_triggers():
		trigger.check_mechanism(self)

func actuator_check():
	for actuator :MechanismActuator in entity_manager.get_actuators():
		actuator.check_mechanism(self)
		
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

func level_finish_check():
	var counter = 0
	for trigger :MechanismTrigger in entity_manager.get_triggers():
		if trigger is not LevelFinishPoint:
			continue
		if not trigger.is_activated():
			return
		var character = entity_manager.get_character_at(trigger.get_coords())
		if not character or character.is_dead():
			return 
		counter += 1
	if counter <= 0:
		return 
	raise_event(Events.LevelFinishedEvent.new())
		

## Trigger
func entity_above(coords:Vector2i) -> bool:
	var entity = entity_manager.get_entity_at(coords)
	return entity and not entity_manager.is_dead(entity)

func enemy_all_dead() -> bool:
	return entity_manager.get_enemies().size() == 0

	
