@icon("res://assets/icons/entity_debugger.svg")
class_name EntityDebugger extends Node

@export var enable := true

var entity:Entity

func _ready() -> void:
	if not enable:
		queue_free()
		return 
	entity = get_parent()
	
func _process(_delta: float) -> void:
	if entity.has_component(Activate):
		DebugLabel.set_value("Activate", entity.get_component(Activate).is_activated())
	if entity.has_component(Health):
		DebugLabel.set_value("Health", entity.get_component(Health).get_health())
		DebugLabel.set_value("Dead", entity.get_component(Health).is_dead())
	if entity.has_component(Obstacle):
		DebugLabel.set_value("ObstacleType", entity.get_component(Obstacle).get_type())
	if entity.has_component(Transform):
		DebugLabel.set_value("TransformZ", entity.get_component(Transform).get_zdepth())
		
