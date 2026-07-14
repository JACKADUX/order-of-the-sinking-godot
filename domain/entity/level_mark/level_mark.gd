class_name LevelMark extends Node2D

@onready var sprite_2d: Sprite2D = %Sprite2D

@export var level_scene:PackedScene
@export var finished:=false
@export var activated := true

func _enter_tree() -> void:
	add_to_group(Const.GROUP_LEVEL_MARK)
	
func _exit_tree() -> void:
	remove_from_group(Const.GROUP_LEVEL_MARK)
	
func _ready() -> void:
	if not level_scene:
		queue_free()
		return 
	update()
	
func is_activated() -> bool:
	return activated or finished

func set_finished(value:bool):
	if value == finished:
		return 
	# NOTE:如果已经完成过不能设置为false
	finished = finished or value
	update()

func set_activate(value:bool):
	activated = value
	update()

func get_data() -> Dictionary:
	return {
		"level_scene":level_scene.resource_path,
		"finished":finished,
		"activated":activated,
	}
	
func set_data(data:Dictionary):
	set_finished(data.get("finished", false))
	set_activate(data.get("activated", activated))
	
	
func update():
	if not is_inside_tree():
		return 
	if finished:
		sprite_2d.texture.x = 2
	elif activated:
		sprite_2d.texture.x = 0
	else:
		sprite_2d.texture.x = 1
		
