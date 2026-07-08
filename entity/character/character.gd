class_name Character extends Entity

@onready var sprite_2d: Sprite2D = %Sprite2D

func _enter_tree() -> void:
	super()
	add_to_group(Const.GROUP_CHARACTER)

func _exit_tree() -> void:
	remove_from_group(Const.GROUP_CHARACTER)
	super()
	
func _ready() -> void:
	var d = 1/8.0
	var color = Color(1.0, 1.0, 1.0, 1.0)
	match get_component(Ability).get_type():
		1: color = Color(0.867, 0.176, 0.176, 1.0)
		2: color = Color(0.376, 0.867, 0.176, 1.0)
		3: color = Color(0.176, 0.3, 0.867, 1.0)
		4: color = Color(0.862, 0.867, 0.176, 1.0)
		5: color = Color(0.651, 0.176, 0.867, 1.0)
		6: color = Color(0.176, 0.867, 0.867, 1.0)
	sprite_2d.modulate = color
	
func update_with(component:Component, _key:=""):
	super(component, _key)
	if component is Creature:
		var crystalize = component.is_crystalized()
		sprite_2d.texture.y = 4 if crystalize else 7
