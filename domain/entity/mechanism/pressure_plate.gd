class_name PressurePlate extends MechanismTrigger

@onready var sprite_2d: Sprite2D = %Sprite2D

func update_with(component:Component, key:=""):
	super(component, key)
	if component is Activate:
		sprite_2d.texture.x = 1 if component.is_activated() else 0


func check_mechanism(service:MechanismService):
	var activate :Activate= get_component(Activate)
	activate.set_activate(service.entity_above(get_coords()))
	

	
