class_name Enemy extends Entity


@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var crystal: Sprite2D = %Crystal

func _enter_tree() -> void:
	super()
	add_to_group(Const.GROUP_ENEMY)

func _exit_tree() -> void:
	remove_from_group(Const.GROUP_ENEMY)
	super()

func update_with(component:Component, _key:="", tween:Tween=null):
	super(component, _key, tween)
	if component is Creature:
		var crystalize = component.is_crystalized()
		crystal.visible = crystalize
		sprite_2d.visible = not crystalize
func check_battle(battle_service:BattleService):
	pass
