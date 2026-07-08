class_name EnemyCounter extends MechanismTrigger

func check(entity_manager:EntityManager):
	var activate :Activate= get_component(Activate)
	var alive_enemies_count = entity_manager.get_enemies().size()
	activate.set_activate(alive_enemies_count == 0)
