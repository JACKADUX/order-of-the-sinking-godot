class_name Application extends Node

signal event_rasied(event:BaseEvent)

var services :Dictionary[String, Service] = {}
var managers :Dictionary[String, Manager] = {}

func register_service(service:Service) -> Service:
	services[service.get_script().get_global_name()] = service
	service.event_rasied.connect(handle_event)
	return service

func get_service(script:GDScript) -> Service:
	return services.get(script.get_global_name())

func register_manager(manager:Manager) -> Manager:
	managers[manager.get_script().get_global_name()] = manager
	manager.event_rasied.connect(handle_event)
	return manager

func get_manager(script:GDScript) -> Manager:
	return managers.get(script.get_global_name())

func handle_event(event:BaseEvent):
	pass

func raise_event(event:BaseEvent) -> void:
	event_rasied.emit(event)
