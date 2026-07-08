@abstract class_name Service

signal event_rasied(event:BaseEvent)

func update() -> void:
	pass

func raise_event(event:BaseEvent) -> void:
	event_rasied.emit(event)
