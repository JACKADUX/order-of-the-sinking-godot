class_name EnemyCounter extends MechanismTrigger

func check_mechanism(service:MechanismService):
	var activate :Activate= get_component(Activate)
	activate.set_activate(service.enemy_all_dead())
