class_name Character5 extends Character

@onready var reference_rect: ReferenceRect = %ReferenceRect

func update_with(component:Component, _key:="", tween:Tween=null):
	super(component, _key, tween)
	if component is Activate:
		reference_rect.visible = component.is_activated()
