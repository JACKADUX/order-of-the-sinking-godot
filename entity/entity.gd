@abstract
class_name Entity extends Node2D

@export var component_manager:ComponentManager

var _id := UUID.v4()

func _enter_tree() -> void:
	add_to_group(Const.GROUP_ENTITY)
	if not component_manager:
		component_manager = get_child(0) if get_child(0) is ComponentManager else null
		
func _exit_tree() -> void:
	remove_from_group(Const.GROUP_ENTITY)


func get_id() -> String:
	return _id

func get_component(script:GDScript) -> Component:
	if not component_manager:
		return null
	return component_manager.get_component(script)

func get_data() -> Dictionary:
	return {
		"id":get_id(),
		"component_data": component_manager.get_data()
	}

func set_data(data:Dictionary):
	_id = data.get("id", _id)
	component_manager.set_data(data.get("component_data", {}))

func get_coords() -> Vector2i:
	var coords = get_component(Coords)
	return Vector2i.ZERO if not coords else coords.get_coords()

func set_coords(value:Vector2i):
	var coords = get_component(Coords)
	if coords:
		coords.set_value("coords", value)

func move_to(coords:Vector2i):
	set_coords(coords)
	# FIXME: 如果等动画，数据会对不上
	#var tween = create_tween()
	#tween.set_ease(Tween.EASE_IN_OUT)
	#tween.tween_property(self, "global_position", Vector2(coords*Const.TILE), 0.1)
	#tween.tween_callback(set_coords.bind(coords))

func update_with(key:String, value):
	pass

func handle_event(event:BaseEvent):
	if event is Events.InitEvent:
		set_coords(Vector2i(floor(global_position / Const.TILE)))
