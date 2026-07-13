class_name LevelMark extends Node2D

@onready var sprite_2d: Sprite2D = %Sprite2D

@export var level_scene:PackedScene
@export var finished:=false

func _enter_tree() -> void:
	add_to_group(Const.GROUP_LEVEL_MARK)
	
func _exit_tree() -> void:
	remove_from_group(Const.GROUP_LEVEL_MARK)
	
func _ready() -> void:
	if not level_scene:
		queue_free()
		return 
