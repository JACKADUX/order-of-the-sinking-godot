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
	if component_manager:
		component_manager.component_value_changed.connect(_store_component_data_changed)
		
func _exit_tree() -> void:
	remove_from_group(Const.GROUP_ENTITY)

func _ready() -> void:
	if Engine.is_editor_hint():
		return 
	if not visible:
		queue_free()
		return 
	
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

func update_with(component:Component, _key:="", tween:Tween=null):
	## WARNING : 覆写该方法时记得 super(...) 否则可能会造成实体无法移动的情况
	if component is Transform:
		queue_redraw()
		tween.tween_property(self, "global_position", Vector2(component.get_coords()*Const.TILE), 0.2)
	elif component is Health:
		if component.is_dead():
			modulate.a = 0.1
		else:
			modulate.a = 1
			
func _draw() -> void:
	var center = Vector2i.ONE*Const.HALF_TILE
	draw_circle(center+get_direction()*Const.HALF_TILE, 2, Color.GREEN)
			
func handle_event(event:BaseEvent):
	if event is Events.InitEvent:
		set_coords(Vector2i(floor(global_position / Const.TILE)))
		set_direction(Const.DIRECTIONS[direction])
	
	if event is Events.BeforeUndoEvent:
		_before_data_changed()
	
	if event is Events.BeforeDataChangedEvent:
		_before_data_changed()
		
	if event is Events.DataChangedEvent:
		_apply_data_changed(event.get_kwarg_with_default(event.K_IMMEDIATE, false))
	
var _animation_tween:Tween
var _data_cache := []
func _quick_finish_tween():
	if _animation_tween and _animation_tween.is_valid() and _animation_tween.is_running():
		_animation_tween.pause()
		_animation_tween.custom_step(1000)
		_animation_tween.kill()

func _before_data_changed():
	_quick_finish_tween()
	
func _store_component_data_changed(component:Component, _key:="", _value:Variant=null, _prev:Variant=null):
	_data_cache.append(component)
	
func _apply_data_changed(immediate:=false):
	_animation_tween = create_tween()
	_animation_tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	for component in _data_cache:
		update_with(component, "",_animation_tween)
	if not _animation_tween.has_tweeners():
		_animation_tween.kill()
	if immediate:
		_quick_finish_tween()
	_data_cache.clear()
