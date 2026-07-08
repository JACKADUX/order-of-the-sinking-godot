@abstract
class_name Component extends Node

signal value_changed(key:String)

func get_entity() -> Entity:
	return owner

func get_data() -> Dictionary:
	return {}
	
func set_data(data:Dictionary):
	set_block_signals(true)
	for key in data:
		set_value(key, data[key])
	set_block_signals(false)
	value_changed.emit("_all_")
	
func raise_value_changed(key:=""):
	value_changed.emit(key)

func set_value(key:String, value:Variant):
	if get(key) == value:
		return 
	set(key, value)
	value_changed.emit(key)
