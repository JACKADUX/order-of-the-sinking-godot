@icon("res://assets/icons/entity.svg")
@abstract
class_name Entity extends Node2D

@export var direction:=Const.Direction.RIGHT
@export var component_manager:ComponentManager

var _id := UUID.v4()

func _enter_tree() -> void:
	add_to_group(Const.GROUP_ENTITY)
	if not component_manager:
		component_manager = get_child(0) if get_child(0) is ComponentManager else null
		
func _exit_tree() -> void:
	remove_from_group(Const.GROUP_ENTITY)

func _ready() -> void:
	if Engine.is_editor_hint():
		return 
	if not visible:
		queue_free()

func get_id() -> String:
	return _id

func has_component(script:GDScript) -> bool:
	return component_manager.has_component(script) if component_manager else false

func get_component(script:GDScript) -> Component:
	if not component_manager:
		return null
	return component_manager.get_component(script)

func get_data() -> Dictionary:
	return {
		"iid":get_instance_id(),
		"id":get_id(),
		"component_data": component_manager.get_data()
	}

func set_data(data:Dictionary):
	_id = data.get("id", _id)
	component_manager.set_data(data.get("component_data", {}))

func get_coords() -> Vector2i:
	var entity_transform :Transform= get_component(Transform)
	return Vector2i.ZERO if not entity_transform else entity_transform.get_coords()

func set_coords(value:Vector2i):
	var entity_transform :Transform= get_component(Transform)
	entity_transform.set_coords(value)

func get_direction() -> Vector2i:
	var entity_transform :Transform= get_component(Transform)
	return Vector2i.RIGHT if not entity_transform else entity_transform.get_direction() 

func set_direction(value:Vector2i):
	var entity_transform :Transform= get_component(Transform)
	entity_transform.set_direction(value)

func get_zdepth() -> int:
	var entity_transform :Transform= get_component(Transform)
	return 0 if not entity_transform else entity_transform.get_zdepth()

func set_zdepth(value:int):
	var entity_transform :Transform= get_component(Transform)
	entity_transform.set_zdepth(value)

func move_to(coords:Vector2i):
	set_coords(coords)
	# FIXME: 如果等动画，数据会对不上
	#var tween = create_tween()
	#tween.set_ease(Tween.EASE_IN_OUT)
	#tween.tween_property(self, "global_position", Vector2(coords*Const.TILE), 0.1)
	#tween.tween_callback(set_coords.bind(coords))

func update_with(component:Component, _key:=""):
	# WARNING : 覆写该方法时记得 super(...) 否则可能会造成实体无法移动的情况
	if component is Transform:
		global_position = component.get_coords()*Const.TILE
		queue_redraw()
	elif component is Health:
		if component.is_dead():
			modulate.a = 0.5
		else:
			modulate.a = 1

func _draw() -> void:
	var center = Vector2i.ONE*Const.HALF_TILE
	draw_circle(center+get_direction()*Const.HALF_TILE, 2, Color.GREEN)
			
				
func handle_event(event:BaseEvent):
	if event is Events.InitEvent:
		set_coords(Vector2i(floor(global_position / Const.TILE)))
		set_direction(Const.DIRECTIONS[direction])
