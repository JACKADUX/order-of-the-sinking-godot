class_name LevelFinishedChecker extends MechanismTrigger

@export var level_mark : LevelMark

func check_mechanism(_service:MechanismService):
	if not level_mark:
		return 
	var activate :Activate= get_component(Activate)
	activate.set_activate(level_mark.finished)
