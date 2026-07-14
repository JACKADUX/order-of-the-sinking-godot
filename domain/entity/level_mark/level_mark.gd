class_name LevelMark extends Node2D

@onready var sprite_2d: Sprite2D = %Sprite2D

@export var level_scene:PackedScene
@export var finished:=false:
	set(v):
		finished = v
		if is_inside_tree():
			sprite_2d.texture.x = 2 if finished else 0

func _enter_tree() -> void:
	add_to_group(Const.GROUP_LEVEL_MARK)
	
func _exit_tree() -> void:
	remove_from_group(Const.GROUP_LEVEL_MARK)
	
func _ready() -> void:
	if not level_scene:
		queue_free()
		return 

func set_finished(value:bool):
	# NOTE:如果已经完成过不能设置为false
	finished = finished or value

func get_data() -> Dictionary:
	return {
		"level_scene":level_scene.resource_path,
		"finished":finished,
	}
	
func set_data(data:Dictionary):
	finished = data.get("finished", finished)
