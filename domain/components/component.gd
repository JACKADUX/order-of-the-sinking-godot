@icon("res://assets/icons/component.svg")
@abstract
class_name Component extends Node

signal value_changed(key:String, value:Variant, prev:Variant)

func get_entity() -> Entity:
	return owner

func get_data() -> Dictionary:
	return {}
	
func set_data(data:Dictionary):
	set_block_signals(true)
	for key in data:
		set_value(key, data[key])
	set_block_signals(false)
	value_changed.emit("", null, null)
	
func raise_value_changed(key:=""):
	value_changed.emit(key)

func set_value(key:String, value:Variant):
	var prev = get(key)
	if prev == value:
		return 
	set(key, value)
	value_changed.emit(key, value, prev)
