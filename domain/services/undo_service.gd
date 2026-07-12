class_name UndoService extends Service

var undo_datas := []

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
	for data in datas:
		var item = instance_from_id(data.iid)
		if not item:
			printerr("数据不应该丢失")
			continue
		item.set_data(data)

func get_history_count() -> int:
	return undo_datas.size()

func undo():
	if undo_datas.size() == 1: 
		apply_datas(undo_datas[0]) # NOTE : 总是保留初始状态
	else:
		apply_datas(undo_datas.pop_back())
	notify_changed()

func reset():
	if undo_datas.size() != 1:
		add_undo(collect_datas())
		apply_datas(undo_datas[0])
	notify_changed()
	
func notify_changed():
	raise_event(Events.DataChangedEvent.new())
