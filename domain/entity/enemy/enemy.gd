class_name Enemy extends Entity


@onready var sprite_2d: Sprite2D = %Sprite2D

func _enter_tree() -> void:
	super()
	add_to_group(Const.GROUP_ENEMY)

func _exit_tree() -> void:
	remove_from_group(Const.GROUP_ENEMY)
	super()

func update_with(component:Component, _key:=""):
	super(component, _key)
	if component is Creature:
		var crystalize = component.is_crystalized()
		#sprite_2d.texture.y = 4 if crystalize else 6

func check_battle(battle_service:BattleService):
	pass
