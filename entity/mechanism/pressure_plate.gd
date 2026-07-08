class_name PressurePlate extends MechanismTrigger

@onready var sprite_2d: Sprite2D = %Sprite2D

func update_with(key:String, value):
	match key:
		Activate.K_ACTIVATE:
			sprite_2d.texture.x = 1 if value else 0

func check(entity_manager:EntityManager):
	var activate :Activate= get_component(Activate)
	var value = entity_manager.get_entity_at(get_coords()) != null
	activate.set_activate(value)
	
