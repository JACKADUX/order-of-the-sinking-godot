class_name UndoService extends Service

var undo_datas := []

func get_data() -> Dictionary:
	add_undo(collect_datas()) # NOTE: 退出前的状态也要保留
	return {
		"undo_datas":undo_datas,
	}
	
func set_data(data:Dictionary):
	undo_datas = data.get("undo_datas", [])

func clear():
	undo_datas.clear()

func warp(fn:Callable):
	var before_datas = collect_datas()
	fn.call()
	var after_datas = collect_datas()
	if hash(before_datas) != hash(after_datas):
		add_undo(before_datas)
		notify_changed()

func add_undo(before_datas:Array):
	undo_datas.append(before_datas)
		
func collect_datas() -> Array:
	var datas = []
	for item in entity_manager.get_all_entities():
		datas.append(item.get_data())
	return datas

func apply_datas(datas:Array): 
	# 复用数据
	var quick_data = {}
	for entity :Entity in entity_manager.get_all_entities():
		var type_entities = quick_data.get_or_add(entity.scene_file_path, [])
		type_entities.append(entity)
	
	# 如果不存在就创建
	for data in datas:
		var scene_file_path = data.get("scene_file_path","")
		if not scene_file_path:
			print("warning: undoredo service::scene_file_path 中 scene_file_path 属性缺失而跳过")
			continue
		var type_entities = quick_data.get(scene_file_path)
		var entity:Entity
		if not type_entities:
			entity = load(scene_file_path).instantiate()
			entity_manager.add_child(entity)
		else:
			entity = type_entities.pop_back()
		entity.set_data(data)
	
	# 移除多余的对象
	for type_entities in quick_data.values():
		for entity in type_entities:
			entity.queue_free()

func get_history_count() -> int:
	return undo_datas.size()

func undo():
	notify_before_undo()
	if undo_datas.size() == 1: 
		apply_datas(undo_datas[0]) # NOTE : 总是保留初始状态
	else:
		apply_datas(undo_datas.pop_back())
	notify_changed(true)

func reset():
	if undo_datas.size() != 1:
		notify_before_undo()
		add_undo(collect_datas())
		apply_datas(undo_datas[0])
	notify_changed(true)
	
func notify_changed(immediate := false):
	var event = Events.DataChangedEvent.new()
	if immediate:
		event.add_kwarg(event.K_IMMEDIATE,immediate)
	raise_event(event)
	
func notify_before_undo():
	raise_event(Events.BeforeUndoEvent.new())
	
