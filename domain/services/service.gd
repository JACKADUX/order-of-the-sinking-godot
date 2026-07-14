@abstract class_name Service

signal event_rasied(event:BaseEvent)

var tilemap_manager:TileMapManager
var entity_manager:EntityManager

func _init(app:Application) -> void:
	entity_manager = app.get_manager(EntityManager)
	tilemap_manager = app.get_manager(TileMapManager)
	
func update() -> void:
	pass

func raise_event(event:BaseEvent) -> void:
	event_rasied.emit(event)

func get_data() -> Dictionary:
	return {}
	
func set_data(data:Dictionary):
	pass
