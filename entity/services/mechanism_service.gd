class_name MechanismService extends Service

var tilemap_manager:TileMapManager
var entity_manager:EntityManager

func _init(_tilemap_manager:TileMapManager, _entity_manager:EntityManager) -> void:
	tilemap_manager = _tilemap_manager
	entity_manager = _entity_manager

func update():
	trigger_check()
	actuator_check()
	#door_smash_check()
						
func trigger_check():
	for trigger : MechanismTrigger in entity_manager.get_triggers():
		trigger.check(entity_manager)

func actuator_check():
	for actuator :MechanismActuator in entity_manager.get_actuators():
		actuator.check()
		
func door_smash_check():
	var entities = entity_manager.get_tagetable_entites()
	var any_dead := false
	var is_character := false
	for actuator :MechanismActuator in entity_manager.get_actuators():
		if actuator is Door and not actuator.is_activated():
			var coords = actuator.get_coords()
			for entity :Entity in entities:
				var health = entity.get_component(Health)
				if health and entity.get_coords() == coords:
					health.to_death()
					any_dead = true
					if entity is Character:
						is_character = true
					print(actuator)
	if not any_dead:
		return 
	if is_character:
		raise_event(Events.CharacterDeadEvent.new())
	raise_event(Events.DataChangedEvent.new())
	
