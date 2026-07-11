class_name ActionService extends Service

var entity_manager:EntityManager

func _init(app:Application) -> void:
	entity_manager = app.get_manager(EntityManager)


func update() -> void:
	pass
