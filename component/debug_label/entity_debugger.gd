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
	DebugLabel.set_value("Activate", entity.get_component(Activate).is_activated())
	DebugLabel.set_value("ObstacleType", entity.get_component(Obstacle).get_type())
