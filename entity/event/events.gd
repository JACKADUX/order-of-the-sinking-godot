class_name Events

class DataChangedEvent extends BaseEvent:
	static func get_event_name() -> String:
		return "DataChangedEvent"

class EnemyDeadEvent extends BaseEvent:
	static func get_event_name() -> String:
		return "EnemyDeadEvent"
