@abstract class_name Service

signal event_rasied(event:BaseEvent)

func _init(app:Application) -> void:
	pass
	
func update() -> void:
	pass

func raise_event(event:BaseEvent) -> void:
	event_rasied.emit(event)
