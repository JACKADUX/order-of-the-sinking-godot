class_name Grass extends Entity

@onready var sprite_2d: Sprite2D = %Sprite2D

func update_with(component:Component, _key:=""):
	super(component, _key)
	if component is Creature:
		var crystalize = component.is_crystalized()
		sprite_2d.texture.y = 4 if crystalize else 5
		var obs :Obstacle = get_component(Obstacle)
		obs.set_type(Obstacle.Type.MOVABLE if crystalize else Obstacle.Type.WALL)
