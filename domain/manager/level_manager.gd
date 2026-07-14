class_name LevelManager extends Manager

var _marker_cache :Dictionary[Vector2i, LevelMark]= {}
var _scene_map :Dictionary[String, LevelMark]= {}
func init_manager():
	for mark :LevelMark in get_level_marks():
		_marker_cache[get_coords(mark)] = mark
		if mark.level_scene:
			_scene_map[mark.level_scene.resource_path] = mark

func get_level_marks() -> Array:
	return Engine.get_main_loop().get_nodes_in_group(Const.GROUP_LEVEL_MARK)

func get_level_mark_at(coords:Vector2i) -> LevelMark:
	return _marker_cache.get(coords)

func get_coords(node:Node2D) -> Vector2i:
	return Vector2i(floor(node.global_position / Const.TILE))

func get_data() -> Dictionary:
	return {
		"level_datas": get_level_marks().map(func(l): return l.get_data())
	}
	
func set_data(data:Dictionary):
	for level_data in data.get("level_datas", []):
		var level_mark :LevelMark= _scene_map.get(level_data.get("level_scene", ""))
		if not level_mark:
			continue
		level_mark.set_data(level_data)

func set_level_finished(scene_path:String, finished:bool):
	var level_mark = _scene_map.get(scene_path)
	if not level_mark:
		return 
	level_mark.set_finished(finished)
	var level_group = level_mark.get_parent()
	if level_group is not LevelMarkGroup:
		return 
	var index = level_mark.get_index()
	var children = level_group.get_children()
	if index >= children.size()-1:
		return
	var next = children[index+1]
	next.set_activate(true)
	
