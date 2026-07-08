class_name Door extends MechanismActuator

@onready var sprite_2d: Sprite2D = %Sprite2D
@export var triggers: Array[MechanismTrigger] = []

func _ready() -> void:
	super()
	for child in get_children():
		if child is MechanismTrigger and child not in triggers:
			triggers.append(child)
	
func update() -> void:
	sprite_2d.texture.x = 1 if is_activated() else 0
	if is_activated():
		remove_component(Movable)
	else:
		var movable = Movable.new()
		movable.obstacle = true
		add_component(movable)

func check_triggers():
	set_active(triggers.all(func(t): return t.is_activated()))
		
