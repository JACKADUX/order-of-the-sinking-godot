@abstract
class_name Component extends Resource

signal value_changed(key:String)

var _entity:Entity

func get_data() -> Dictionary:
	return {
		"id":get_instance_id(),
	}
func set_data(_data:Dictionary):
	pass

func raise_value_changed(key:=""):
	value_changed.emit(key)
