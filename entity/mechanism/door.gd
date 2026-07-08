class_name Door extends MechanismActuator

@onready var sprite_2d: Sprite2D = %Sprite2D
@export var triggers: Array[MechanismTrigger] = []

func _ready() -> void:
	for child in get_children():
		if child is MechanismTrigger and child not in triggers:
			triggers.append(child)
	
func update_with(key:String, value):
	match key:
		Activate.K_ACTIVATE:
			sprite_2d.texture.x = 1 if value else 0
	
func check():
	var activate :Activate= get_component(Activate)
	activate.set_activate(triggers.all(func(t): return t.is_activated()))
		
