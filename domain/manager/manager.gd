@icon("res://assets/icons/manager.svg")
@abstract
class_name Manager extends Node2D

signal event_rasied(event:BaseEvent)

func init_manager():
	pass

func raise_event(event:BaseEvent) -> void:
	event_rasied.emit(event)

func get_data() -> Dictionary:
	return {}
	
func set_data(data:Dictionary):
	pass
