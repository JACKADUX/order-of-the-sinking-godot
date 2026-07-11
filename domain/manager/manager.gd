@icon("res://assets/icons/manager.svg")
@abstract
class_name Manager extends Node2D

signal event_rasied(event:BaseEvent)

func raise_event(event:BaseEvent) -> void:
	event_rasied.emit(event)
