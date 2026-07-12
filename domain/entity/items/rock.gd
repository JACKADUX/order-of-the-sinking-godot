class_name Rock extends Entity

@onready var sprite_2d: Sprite2D = %Sprite2D

# NOTE: 石头会被机关打碎所以有health
func update_with(component:Component, _key:=""):
	super(component, _key)
	if component is Transform:
		if component.get_zdepth() >= 0:
			z_index = 0
			sprite_2d.position = Vector2(Const.HALF_TILE,11)
		else:
			z_index = -2
			sprite_2d.position = Vector2(Const.HALF_TILE, 11 +Const.HALF_TILE)
			
	
