class_name Rock extends Entity

@onready var sprite_2d: Sprite2D = %Sprite2D


func update_with(component:Component, _key:="", tween:Tween=null):
	super(component, _key, tween)
	if component is Transform :
		var above_water = component.get_zdepth() >= 0
		var tween_x = create_tween()
		tween_x.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
		tween_x.tween_interval(0.1)
		tween_x.tween_property(self, "z_index", -2 if not above_water else 0, 0.1)
		tween_x.set_parallel(true)
		tween_x.tween_property(sprite_2d, "position", Vector2(Const.HALF_TILE, 11 +Const.HALF_TILE) if not above_water else Vector2(Const.HALF_TILE,11), 0.1)
		tween.tween_subtween(tween_x)
