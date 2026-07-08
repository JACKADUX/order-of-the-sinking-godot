class_name Events


class InitEvent extends BaseEvent:
	static func get_event_name() -> String:
		return "InitEvent"

class DataChangedEvent extends BaseEvent:
	static func get_event_name() -> String:
		return "DataChangedEvent"

class EnemyDeadEvent extends BaseEvent:
	static func get_event_name() -> String:
		return "EnemyDeadEvent"

class CharacterDeadEvent extends BaseEvent:
	static func get_event_name() -> String:
		return "CharacterDeadEvent"
