@abstract
class_name Entity extends Node2D

@export var direction := Vector2i.DOWN
@export var components__ :Array[Component]  # NOTE: 只是为了方便从编辑器添加
var _components : Dictionary[GDScript,Component]



func _enter_tree() -> void:
	for component in components__:
		add_component(component)
	components__.clear()
	add_to_group(Const.GROUP_ENTITY)

func _exit_tree() -> void:
	remove_from_group(Const.GROUP_ENTITY)

func add_component(component:Component):
	_components[component.get_script()] = component
	component._entity = self 

func remove_component(script:GDScript):
	var component = _components.get(script)
	if not component:
		return 
	#component._entity = null
	_components.erase(script)

func has_component(script:GDScript) -> bool:
	return _components.has(script)

func get_component(script:GDScript) -> Component:
	return _components.get(script)


func get_data() -> Dictionary:
	return {
		"id":get_instance_id(),
		"global_position":global_position,
		"components": _components.values().map(func(c): return c.get_data()),
		"direction":get_direction(),
	}
	
func set_data(data:Dictionary):
	global_position = data.get("global_position", global_position)
	set_direction(data.get("direction", direction))
	for cd in data.get("components", []):
		var component = instance_from_id(cd.id)
		if not component:
			continue
		component.set_data(cd)

func get_direction() -> Vector2i:
	return direction

func set_direction(value:Vector2i):
	direction = value

func get_coords() -> Vector2i:
	return Vector2i(floor(global_position / Const.TILE))

func set_coords(coords:Vector2i):
	global_position = coords*Const.TILE

func move_to(coords:Vector2i):
	set_coords(coords)
	# FIXME: 如果等动画，数据会对不上
	#var tween = create_tween()
	#tween.set_ease(Tween.EASE_IN_OUT)
	#tween.tween_property(self, "global_position", Vector2(coords*Const.TILE), 0.1)
	#tween.tween_callback(set_coords.bind(coords))

func handle_event(_event:BaseEvent):
	pass
