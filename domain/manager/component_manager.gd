@tool
class_name ComponentManager extends Manager

signal component_value_changed(component:Component, key:String, value:Variant, prev:Variant)

var _components : Dictionary[String,Component]

func _ready() -> void:
	if Engine.is_editor_hint():
		return 
	for component in get_children():
		if component is Component:
			add_component(component)

func add_component(component:Component):
	var parent = component.get_parent()
	if parent != null and parent != self:
		printerr(component, " :component 不能有别的父级")
		return 
	if component.get_parent() == null:
		add_child(component)
	_components[component.get_script().get_global_name()] = component
	component.value_changed.connect(func(key:String, value:Variant, prev:Variant):
		component_value_changed.emit(component, key, value, prev)
	)


func remove_component(script:GDScript):
	var component = _components.get(script.get_global_name())
	if not component:
		return 
	_components.erase(script)
	component.queue_free()

func has_component(script:GDScript) -> bool:
	return _components.has(script.get_global_name())

func get_component(script:GDScript) -> Component:
	return _components.get(script.get_global_name())

func get_data() -> Dictionary:
	var data := {}
	for component_name in _components:
		data[component_name] = _components[component_name].get_data()
	return data

func set_data(data:Dictionary):
	for component_name in data:
		if not _components.has(component_name):
			continue
		_components[component_name].set_data(data[component_name])


## HELPERS ----
@export_tool_button("Add Component") var __add__ :Callable = __add_component__
func __add_component__():
	EditorQuickPopupHelper.popup_at_mouse(func(popup:PopupMenu):
		var fdir := "res://domain/components/"
		var files = Array(DirAccess.get_files_at(fdir)).filter(func(f): return f.ends_with(".gd"))
		files.erase("component.gd")
		files.erase("component_manager.gd")
		for file in files:
			popup.add_item(file.get_file().get_basename())
		popup.index_pressed.connect(func(index):
			var file = fdir.path_join(files[index])
			var gdscript :GDScript=load(file)
			var component = gdscript.new()
			add_child(component)
			component.owner = owner
			component.name = gdscript.get_global_name()
		)
	)
	
