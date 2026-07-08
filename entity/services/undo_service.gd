class_name UndoService extends Service

var undo_datas := []

var entity_manager:EntityManager

func _init(_entity_manager:EntityManager) -> void:
	entity_manager = _entity_manager

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
	for item in entity_manager.get_entites():
		datas.append(item.get_data())
	return datas

func apply_datas(datas:Array):
	for data in datas:
		var item = instance_from_id(data.id)
		if not item:
			printerr("数据不应该丢失")
			continue
		item.set_data(data)

func undo():
	if undo_datas.is_empty(): return 
	apply_datas(undo_datas.pop_back())
	notify_changed()

func notify_changed():
	raise_event(Events.DataChangedEvent.new())
