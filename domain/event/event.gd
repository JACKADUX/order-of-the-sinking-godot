@abstract
class_name BaseEvent extends RefCounted
static func get_event_name() -> String:
	return "BaseEvent"

var _kwargs := {}
func _init(...args: Array):
	var index = 0
	for arg in self.get_property_list():
		if (arg.usage & PROPERTY_USAGE_SCRIPT_VARIABLE) != PROPERTY_USAGE_SCRIPT_VARIABLE:
			continue
		if arg.name.begins_with("_"):
			continue
		self.set(arg.name, args[index])
		assert(self.get(arg.name) == args[index],
				"参数类型必须是一致的，否则 set 会无效 。Array[String] ！= Array"
				)
		index += 1
	
	if index < args.size():
		push_error("not all args being used! %d/%d" % [index, args.size()])

func _to_string():
	return "<DomainEvent::%s::%d>" % [get_event_name(), get_instance_id()]


	
func add_kwarg(key: String, value: Variant) -> BaseEvent:
	_kwargs[key] = value
	return self
	
func has_kwarg(key: String):
	return _kwargs.has(key)

func get_kwarg(key: String):
	# 保证调用时这个值一定存在，否则会报错
	return _kwargs[key]
