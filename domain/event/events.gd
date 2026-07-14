class_name Events


class InitEvent extends BaseEvent:
	static func get_event_name() -> String:
		return "InitEvent"

class EnemyDeadEvent extends BaseEvent:
	static func get_event_name() -> String:
		return "EnemyDeadEvent"

class CharacterDeadEvent extends BaseEvent:
	static func get_event_name() -> String:
		return "CharacterDeadEvent"

class UserInputEvent extends BaseEvent:
	static func get_event_name() -> String:
		return "UserInputEvent"
	var action:String
	var data:Dictionary

class BeforeUndoEvent extends BaseEvent:
	static func get_event_name() -> String:
		return "BeforeUndoEvent"

class BeforeDataChangedEvent extends BaseEvent:
	static func get_event_name() -> String:
		return "BeforeDataChangedEvent"

class DataChangedEvent extends BaseEvent:
	const K_IMMEDIATE := "immediate"
	static func get_event_name() -> String:
		return "DataChangedEvent"

class LevelFinishedEvent extends BaseEvent:
	static func get_event_name() -> String:
		return "LevelFinishedEvent"
