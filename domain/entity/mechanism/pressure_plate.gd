class_name PressurePlate extends MechanismTrigger

@onready var sprite_2d: Sprite2D = %Sprite2D

func update_with(component:Component, key:=""):
	super(component, key)
	if component is Activate:
		sprite_2d.texture.x = 1 if component.is_activated() else 0


func check(entity_manager:EntityManager):
	var activate :Activate= get_component(Activate)
	var value = entity_manager.get_entity_at(get_coords()) != null
	activate.set_activate(value)
	
