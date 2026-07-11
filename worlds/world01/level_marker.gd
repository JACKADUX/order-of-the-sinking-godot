@tool
class_name LevelMarker extends Node2D

@onready var sprite_2d: Sprite2D = %Sprite2D

@export var level:PackedScene
@export var finished := false:
	set(v):
		finished = v
		if is_inside_tree():
			update()
@export var activate := false:
	set(v):
		activate = v
		if is_inside_tree():
			update()

func _ready() -> void:
	add_to_group(Const.GROUP_LEVEL_MARKER)
	update()
	
func update():
	var vx = 0
	if finished:
		vx = 2
	elif not activate:
		vx = 1
	sprite_2d.texture.x = vx
