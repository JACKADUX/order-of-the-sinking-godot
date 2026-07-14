class_name Door extends MechanismActuator

@onready var sprite_2d: Sprite2D = %Sprite2D
@export var triggers: Array[MechanismTrigger] = []

func _ready() -> void:
	super()
	for child in get_children():
		if child is MechanismTrigger and child not in triggers:
			triggers.append(child)
	
func update_with(component:Component, key:="", tween:Tween=null):
	super(component, key, tween)
	if component is Activate:
		sprite_2d.texture.x = 1 if component.is_activated() else 0
	
	
func check_mechanism(_service:MechanismService):
	if triggers.is_empty(): 
		# NOTE: 没有 triggers 就保持现状
		return 
	var activate :Activate = get_component(Activate)
	activate.set_activate(triggers.all(func(t): return t.is_activated()))
	var obstacle :Obstacle = get_component(Obstacle)
	obstacle.set_type(Obstacle.Type.GHOST if activate.is_activated() else Obstacle.Type.WALL)
