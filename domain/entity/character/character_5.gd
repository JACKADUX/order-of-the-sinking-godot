class_name Character5 extends Character

@onready var reference_rect: ReferenceRect = %ReferenceRect

func update_with(component:Component, _key:=""):
	super(component, _key)
	if component is Activate:
		reference_rect.visible = component.is_activated()
